#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"

echo "=== Testing codex-md Local CLAUDE Merge ==="

test_dir=$(mktemp -d)
trap "rm -rf $test_dir" EXIT

cat > "$test_dir/CLAUDE.md" << 'EOF'
PROJECT-LINE
EOF

cat > "$test_dir/CLAUDE.local.md" << 'EOF'
LOCAL-LINE
EOF

(
    cd "$test_dir"
    "$REPO_DIR/bin/codex-md" >/dev/null 2>&1
)

if grep -Fq "PROJECT-LINE" "$test_dir/AGENTS.md"; then
    echo "✓ AGENTS.md includes ./CLAUDE.md content"
else
    echo "✗ AGENTS.md missing ./CLAUDE.md content"
    exit 1
fi

if grep -Fq "LOCAL-LINE" "$test_dir/AGENTS.md"; then
    echo "✓ AGENTS.md includes ./CLAUDE.local.md content"
else
    echo "✗ AGENTS.md missing ./CLAUDE.local.md content"
    exit 1
fi

echo ""
echo "codex-md local merge test passed"
