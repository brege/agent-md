#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"

echo "=== Testing claude-md Override ==="

# Test 1: override false (normal merge)
echo "Test 1: override false"
test_dir=$(mktemp -d)
trap "rm -rf $test_dir" EXIT

export HOME="$test_dir"
mkdir -p "$test_dir/.claude"

cat > "$REPO_DIR/user/settings.json" << 'EOF'
{
  "override": false,
  "permissions": {
    "deny": ["Read(~/goodbye/**)"]
  }
}
EOF

"$REPO_DIR/bin/claude-md" >/dev/null 2>&1

deny_count=$(jq '.permissions.deny | length' "$test_dir/.claude/settings.json")
if (( deny_count > 1 )); then
    echo "✓ Merged with distribution (count: $deny_count)"
else
    echo "✗ Merge failed"
    exit 1
fi

# Test 2: override true (use only user settings)
echo "Test 2: override true"
test_dir2=$(mktemp -d)
trap "rm -rf $test_dir2" EXIT

export HOME="$test_dir2"

cat > "$REPO_DIR/user/settings.json" << 'EOF'
{
  "override": true,
  "permissions": {
    "deny": ["Read(~/goodbye/**)"]
  }
}
EOF

"$REPO_DIR/bin/claude-md" >/dev/null 2>&1

deny_count=$(jq '.permissions.deny | length' "$test_dir2/.claude/settings.json")
if (( deny_count == 1 )); then
    echo "✓ Override applied (count: $deny_count)"
else
    echo "✗ Override failed (count: $deny_count)"
    exit 1
fi

if ! jq -e '.override' "$test_dir2/.claude/settings.json" >/dev/null 2>&1; then
    echo "✓ Override key removed"
else
    echo "✗ Override key not removed"
    exit 1
fi

rm "$REPO_DIR/user/settings.json"
echo ""
echo "All tests passed"
