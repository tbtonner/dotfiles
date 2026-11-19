# Mirrors VariableSummaries + FillSendDetails (couchbase-cloud internal/billing/salesforce/sender) for manual reruns.
function aggregate-variable --description 'Salesforce summaries for manually rerun variable billing of a usage date (YYYY-MM-DD)'
    argparse hosted -- $argv
    or return 1

    set -l usage $argv[1]
    if not string match -qr '^\d{4}-\d{2}-\d{2}$' -- $usage
        echo "usage: aggregate-variable [--hosted] <usage date, e.g. 2026-11-08>" >&2
        return 1
    end

    # +reconcile keeps the ID unique when the day was already partly sent; --hosted is for a day that was never sent.
    set -l delivery hosted+reconcile
    set -q _flag_hosted; and set delivery hosted

    # Usage reaches Salesforce 4 days later: billed at +3 days, sent the day after.
    switch (uname)
        case Darwin
            set -f send (date -u -j -v+4d -f %Y-%m-%d $usage +%Y-%m-%d)
        case '*'
            set -f send (date -u -d "$usage + 4 days" +%Y-%m-%d)
    end

    # The summary ID date is unpadded (Go layout 2006:1:2), e.g. 2026:11:5.
    set -l id_date (string split - $send | string replace -r '^0' '' | string join :)

    set -l query "
SELECT
	s.activationId,
	'$send"T00:00:00-08:00"' AS startDate,
	'$send"T00:00:00-08:00"' AS endDate,
	CEIL(s.creditQuantity * 1000000) / 1000000 AS creditQuantity,
	s.productPackage,
	REPLACE(CONCAT(s.activationId, ':', s.databaseId, ':', pkg, ':', cat, ':$delivery:$id_date'), ' ', '') AS dailySummaryId,
	CASE
		WHEN s.usageCategory = 'Private Endpoint Capacity Unit' THEN 'Private Endpoints'
		WHEN s.usageCategory = 'Data API Capacity Unit' THEN 'Data API Endpoints'
		WHEN s.usageCategory IN ['Data Transfer VPC Peering', 'Data Transfer Capacity Unit'] THEN 'Data Transfer'
		WHEN s.usageCategory = 'Columnar Restore' THEN 'Columnar Backup'
		ELSE s.usageCategory
	END AS usageCategory,
	NOW_UTC() AS updateTimestamp,
	'Hosted' AS clusterType,
	s.databaseId,
	s.databaseName,
	s.projectId,
	s.projectName
FROM (
	SELECT
		activationId,
		productPackage,
		usageCategory,
		databaseId,
		ARRAY_AGG(databaseName)[0] AS databaseName,
		ARRAY_AGG(projectId)[0] AS projectId,
		ARRAY_AGG(projectName)[0] AS projectName,
		ROUND(SUM(creditQuantity), 6) AS creditQuantity
	FROM `default` d
	WHERE d._type = 'billing.variable'
		AND d.createdAt >= '$usage'
		AND d.usageDate = '$usage"T00:00:00Z"'
		AND activationId != 'not found'
		AND d.manual = true
	GROUP BY tenantId, activationId, productPackage, usageCategory, databaseId
) AS s
JOIN `default` a ON KEYS s.activationId
LET pkg = REPLACE(REPLACE(LOWER(s.productPackage), ' ', '-'), ':', ''),
	cat = CASE s.usageCategory
		WHEN 'Private Endpoints' THEN 'private-endpoints-connection'
		WHEN 'Private Endpoint Capacity Unit' THEN 'private-endpoints-capacity-unit'
		ELSE LOWER(REPLACE(REPLACE(TRIM(s.usageCategory), ' ', '-'), ':', ''))
	END
WHERE IFMISSINGORNULL(a.environment, '') != 'Free Tier'
	AND a.status IN ['Active', 'Paused', 'Predeployment']
	AND CEIL(s.creditQuantity * 1000000) / 1000000 >= 0.000001
"

    supportal $query
end
