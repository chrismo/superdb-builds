#!/usr/bin/env bash

set -euo pipefail

echo "DEPRECATED: This repo is no longer needed. SuperDB now publishes official releases."
echo "See: https://github.com/brimdata/super/releases"
exit 0

# Parse command line arguments
UPDATE_MODE=false
while [[ $# -gt 0 ]]; do
  case $1 in
    --update|-u)
      UPDATE_MODE=true
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [--update|-u]"
      echo "  --update, -u  Update existing releases instead of skipping them"
      echo "  --help, -h    Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

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
    RELEASE_EXISTS=false
    if gh release view "$VERSION" >/dev/null 2>&1; then
      RELEASE_EXISTS=true
    fi

    # Determine if we should trigger a release
    SHOULD_TRIGGER=false
    if [[ "$RELEASE_EXISTS" == "true" ]]; then
      if [[ "$UPDATE_MODE" == "true" ]]; then
        echo "  → Updating existing release for $VERSION"
        SHOULD_TRIGGER=true
      else
        echo "  ✓ Release $VERSION already exists, skipping"
      fi
    else
      echo "  → Triggering new release for $VERSION"
      SHOULD_TRIGGER=true
    fi

    # Trigger release if needed
    if [[ "$SHOULD_TRIGGER" == "true" ]]; then
      "$SCRIPT_DIR/trigger-release.sh" "$VERSION" "$SHA_REF"
      
      if [[ "$RELEASE_EXISTS" == "true" ]]; then
        echo "  ✓ Successfully updated release for $VERSION"
      else
        echo "  ✓ Successfully triggered new release for $VERSION"
      fi

      # to ensure if we're re-creating a long list, that they'll show up in
      # the repos releases in the same order, oldest to newest.
      echo "    Waiting 60 seconds for next release ..."
      sleep 60
    fi
    echo ""
  else
    echo "Warning: Skipping malformed line: $line"
  fi
done </tmp/versions.txt

# Cleanup
rm -f /tmp/versions.txt

echo "Done processing all versions."
