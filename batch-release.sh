#!/usr/bin/env bash

set -euo pipefail

VERSIONS_URL="https://raw.githubusercontent.com/chrismo/asdf-superdb/main/scripts/versions.txt"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Fetching versions from: $VERSIONS_URL"

# Download versions.txt
if ! curl -sSf "$VERSIONS_URL" -o /tmp/versions.txt; then
  echo "Error: Failed to download versions.txt from $VERSIONS_URL"
  exit 1
fi

echo "Processing versions..."
echo ""

TRIGGERED=0
SKIPPED=0
ERRORS=0

# Process each line in versions.txt
while read -r line; do
  # Skip empty lines and comments
  if [[ -z "$line" || "$line" =~ ^# ]]; then
    continue
  fi

  # Parse version and sha_ref
  if [[ "$line" =~ ^([0-9.]+)[[:space:]]+([a-f0-9]+)$ ]]; then
    VERSION="${BASH_REMATCH[1]}"
    SHA_REF="${BASH_REMATCH[2]}"

    echo "Checking version: $VERSION (sha: $SHA_REF)"

    # Check if release already exists
    if gh release view "$VERSION" >/dev/null 2>&1; then
      echo "  ✓ Release $VERSION already exists, skipping"
      ((SKIPPED++)) || true
    else
      echo "  → Triggering release for $VERSION"
      if "$SCRIPT_DIR/trigger-release.sh" "$VERSION" "$SHA_REF"; then
        echo "  ✓ Successfully triggered release for $VERSION"
        ((TRIGGERED++)) || true

        # to ensure if we're re-creating a long list, that they'll show up in
        # the repos releases in the same order, oldest to newest.
        echo "    Waiting 60 seconds for next release ..."
        sleep 60
      else
        echo "  ✗ Failed to trigger release for $VERSION"
        ((ERRORS++)) || true
      fi
    fi
    echo ""
  else
    echo "Warning: Skipping malformed line: $line"
  fi
done </tmp/versions.txt

# Cleanup
rm -f /tmp/versions.txt

echo "Summary:"
echo "  Triggered: $TRIGGERED releases"
echo "  Skipped: $SKIPPED releases (already exist)"
echo "  Errors: $ERRORS releases"

if [[ $ERRORS -gt 0 ]]; then
  exit 1
fi
