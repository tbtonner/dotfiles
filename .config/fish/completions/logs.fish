complete -c logs -f -a "(docker ps -a --format '{{.Names}}' 2>/dev/null)"
complete -c logs -s t -l tail -d "Follow live, optionally with line count (--tail=N)"
complete -c logs -s h -l help -d "Show usage"
