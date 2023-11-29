#!/bin/bash
#
# Run basic security checks of Go code.

set -e # exit on error
set -x # print what you're doing

##########################################
# https://go.dev/security/best-practices #
##########################################

# Keep your Go version up to date.
curl https://go.dev/VERSION?m=text
go version 
grep '^go ' go.mod

# Scan source code for vulnerabilities. See https://stackoverflow.com/a/77565047
# for how to run govulncheck with a specific Go version.
govulncheck ./...

# Test with fuzzing to uncover edge-case exploits.
go test ./...
go test -fuzz=./... -fuzztime=10s

# Examine suspicious code constructs.
go vet ./...

#####################################
# https://github.com/securego/gosec #
#####################################

# Inspect source code for security problems.
gosec -quiet -confidence=high -severity=high ./...