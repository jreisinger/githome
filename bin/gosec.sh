#!/bin/bash
#
# Run basic security checks of Go code.

set -e # exit on error
set -u # exit on unset variable
# set -x # print what you're doing

##################
# Security hints #
##################

# https://go.dev/security/best-practices
echo '--> You should keep your Go version up to date'
UPSTREAM=$(curl -s https://go.dev/VERSION?m=text | head -1)
INSTALLED=$(go version | cut -d ' ' -f 3)
GOMOD=$(grep '^go ' go.mod | sed 's/ //')
printf "Upstream\t%s\n" "$UPSTREAM"
printf "Installed\t%s\n" "$INSTALLED"
printf "In go.mod\t%s\n" "$GOMOD"

# https://stackoverflow.com/questions/67201708/go-update-all-modules
echo '--> To update all dependencies to latest version run'
echo 'go get -u ./...'
echo 'go mod tidy'

###################
# Security checks #
###################

echo '==> Scan source code for vulnerabilities (govulncheck)'
# See https://stackoverflow.com/a/77565047 for how to run govulncheck with a
# specific Go version.
#
go install golang.org/x/vuln/cmd/govulncheck@latest
govulncheck ./...

echo '==> Examine suspicious code constructs (go vet)'
go vet ./...

# https://github.com/securego/gosec
echo '==> Inspect source code for security problems (gosec)'
go install github.com/securego/gosec/v2/cmd/gosec@latest
gosec -quiet -confidence=high -severity=high ./...