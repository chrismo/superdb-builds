#!/usr/bin/env bash

set -euo pipefail

echo "DEPRECATED: This repo is no longer needed. SuperDB now publishes official releases."
echo "See: https://github.com/brimdata/super/releases"
exit 0

# Check if required arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <version> <sha_ref>"
    echo "  version: Version string for the build/release (required)"
    echo "  sha_ref: SHA or ref to build (required)"
    echo ""
    echo "Example: $0 '0.1.0' 'v0.1.0'"
    exit 1
fi

VERSION="$1"
SHA_REF="$2"
CREATE_RELEASE="${3:-true}"

echo "Triggering release workflow with:"
echo "  Version: $VERSION"
echo "  SHA/Ref: $SHA_REF"
echo "  Create Release: $CREATE_RELEASE"

# Trigger the workflow using GitHub CLI
gh workflow run release.yml \
    --field version="$VERSION" \
    --field sha_ref="$SHA_REF" \
    --field create_release="$CREATE_RELEASE"

echo "Workflow triggered successfully!"
echo "Check the status at: https://github.com/$(gh repo view --json owner,name -q '.owner.login + "/" + .name')/actions"
