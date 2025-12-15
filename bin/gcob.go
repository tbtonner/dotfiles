package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func branchName(url, desc string) string {
	urlSplit := strings.Split(url, "/")
	av := urlSplit[len(urlSplit)-1][:9]

	if desc == "" {
		return av
	}

	return fmt.Sprintf("%s_%s", av, strings.Join(strings.Split(desc, " "), "_"))
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("usage: gcob <url> [description]")
		os.Exit(1)
	}

	url := os.Args[1]
	desc := ""
	if len(os.Args) >= 3 {
		desc = os.Args[2]
	}

	branch := branchName(url, desc)

	// run: git checkout -b <branch>
	cmd := exec.Command("git", "checkout", "-b", branch)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		fmt.Println("error:", err)
		os.Exit(1)
	}
}
