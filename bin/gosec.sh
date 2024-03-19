#!/bin/bash
#
# Run basic security checks of Go code.

set -e # exit on error
# set -x # print what you're doing

##########################################
# https://go.dev/security/best-practices #
##########################################

echo '--> Keep your Go version up to date'
UPSTREAM=$(curl -s https://go.dev/VERSION?m=text | head -1)
INSTALLED=$(go version | cut -d ' ' -f 3)
GOMOD=$(grep '^go ' go.mod | sed 's/ //')
printf "Upstream\t%s\n" "$UPSTREAM"
printf "Installed\t%s\n" "$INSTALLED"
printf "In go.mod\t%s\n" "$GOMOD"

echo '--> Scan source code for vulnerabilities'
# See https://stackoverflow.com/a/77565047 for how to run govulncheck with a
# specific Go version.
govulncheck ./...

echo '--> Test with fuzzing to uncover edge-case exploits'
go test ./...
go test -fuzz=./... -fuzztime=10s

echo '--> Examine suspicious code constructs'
go vet ./...

#####################################
# https://github.com/securego/gosec #
#####################################

echo '--> Inspect source code for security problems'
gosec -quiet -confidence=high -severity=high ./...