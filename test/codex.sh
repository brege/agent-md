#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"

test_local_claude_merge() {
    echo "=== Testing codex-md Local CLAUDE Merge ==="

    local test_dir
    test_dir=$(mktemp -d)
    trap "rm -rf $test_dir" RETURN

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
}

test_tracked_agents_preserved() {
    echo ""
    echo "=== Testing codex-md tracked AGENTS.md preservation ==="

    local test_dir
    test_dir=$(mktemp -d)
    trap "rm -rf $test_dir" RETURN

    (
        cd "$test_dir"
        git init --quiet
        git config user.email "test@example.invalid"
        git config user.name "agent-md test"

        printf "%s\n" "TRACKED-PROJECT-POLICY" > AGENTS.md
        printf "%s\n" "PROJECT-LINE" > CLAUDE.md

        git add --force AGENTS.md CLAUDE.md
        git commit --quiet --message "test fixture"

        "$REPO_DIR/bin/codex-md" >/dev/null 2>&1
    )

    if grep -Fxq "TRACKED-PROJECT-POLICY" "$test_dir/AGENTS.md"; then
        echo "✓ tracked AGENTS.md was preserved"
    else
        echo "✗ tracked AGENTS.md was overwritten"
        exit 1
    fi

    if grep -Fq "PROJECT-LINE" "$test_dir/AGENTS.md"; then
        echo "✗ generated content was written into tracked AGENTS.md"
        exit 1
    else
        echo "✓ generated content was not written into tracked AGENTS.md"
    fi

    echo ""
    echo "codex-md tracked AGENTS.md preservation test passed"
}

test_local_claude_merge
test_tracked_agents_preserved
