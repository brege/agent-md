#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BIN_DIR="$REPO_DIR/bin"

test_home_relative() {
    echo "=== Testing Home-Relative Paths ==="

    local temp_home=$(mktemp -d)
    local temp_project="$temp_home/projects/test-project"
    local temp_stash=$(mktemp -d)
    trap "rm -rf $temp_home $temp_stash" EXIT

    # Create a test file in the temporary project
    mkdir -p "$temp_project"
    echo "test content" > "$temp_project/AGENTS.md"

    echo "Test 1a: Stashing from home-relative path..."

    # Mock HOME for this test
    export HOME="$temp_home"

    cd "$temp_project"

    # Run agent-md --stash with mocked agent-configs
    AGENT_CONFIGS_DIR="$temp_stash" "$BIN_DIR/agent-md" --stash AGENTS.md

    # Check if symlink was created
    local expected_link="$temp_stash/user/src/projects/test-project/AGENTS.md"

    if [[ -L "$expected_link" ]]; then
        echo "✓ Symlink created at home-relative path: $expected_link"
    else
        echo "✗ Symlink not found at: $expected_link"
        return 1
    fi

    # Verify symlink target
    if [[ "$(readlink "$expected_link")" == "$temp_project/AGENTS.md" ]]; then
        echo "✓ Symlink target is correct"
    else
        echo "✗ Symlink target mismatch"
        echo "  Expected: $temp_project/AGENTS.md"
        echo "  Got: $(readlink "$expected_link")"
        return 1
    fi
}

test_root_relative() {
    echo ""
    echo "=== Testing Root-Relative Paths ==="

    local temp_stash=$(mktemp -d)
    trap "rm -rf $temp_stash" EXIT

    # Create a temporary directory outside HOME
    local temp_root=$(mktemp -d --tmpdir=/tmp stash-test-XXXXXX)
    trap "rm -rf $temp_root $temp_stash" EXIT

    echo "test content" > "$temp_root/AGENTS.md"

    echo "Test 2a: Stashing from root-relative path..."

    cd "$temp_root"

    # Run agent-md --stash with mocked agent-configs
    AGENT_CONFIGS_DIR="$temp_stash" "$BIN_DIR/agent-md" --stash AGENTS.md

    # Extract relative path from temp_root (should be something like tmp/stash-test-XXXXXX)
    local rel_path="${temp_root#/}"
    local expected_link="$temp_stash/user/src/_/$rel_path/AGENTS.md"

    if [[ -L "$expected_link" ]]; then
        echo "✓ Symlink created at root-relative path with _/ prefix"
        echo "  Path: $expected_link"
    else
        echo "✗ Symlink not found at: $expected_link"
        return 1
    fi

    # Verify symlink target
    if [[ "$(readlink "$expected_link")" == "$temp_root/AGENTS.md" ]]; then
        echo "✓ Symlink target is correct"
    else
        echo "✗ Symlink target mismatch"
        return 1
    fi
}

test_missing_source() {
    echo ""
    echo "=== Testing Missing Source File ==="

    local temp_home=$(mktemp -d)
    local temp_project="$temp_home/projects/test-project"
    local temp_stash=$(mktemp -d)
    trap "rm -rf $temp_home $temp_stash" EXIT

    mkdir -p "$temp_project"
    export HOME="$temp_home"
    cd "$temp_project"

    echo "Test 3a: Attempting to stash non-existent file..."

    if AGENT_CONFIGS_DIR="$temp_stash" "$BIN_DIR/agent-md" --stash NONEXISTENT.md 2>/dev/null; then
        echo "✗ agent-md --stash should have failed for missing source"
        return 1
    else
        echo "✓ agent-md --stash correctly failed for missing source file"
    fi
}

test_directory_creation() {
    echo ""
    echo "=== Testing Directory Creation ==="

    local temp_home=$(mktemp -d)
    local temp_project="$temp_home/deeply/nested/project/structure"
    local temp_stash=$(mktemp -d)
    trap "rm -rf $temp_home $temp_stash" EXIT

    mkdir -p "$temp_project"
    echo "test content" > "$temp_project/AGENTS.md"

    export HOME="$temp_home"
    cd "$temp_project"

    echo "Test 4a: Creating nested directory structure..."

    AGENT_CONFIGS_DIR="$temp_stash" "$BIN_DIR/agent-md" --stash AGENTS.md

    local dest_dir="$temp_stash/user/src/deeply/nested/project/structure"

    if [[ -d "$dest_dir" ]]; then
        echo "✓ Destination directory created: $dest_dir"
    else
        echo "✗ Destination directory not created"
        return 1
    fi
}

test_no_duplicate_symlinks() {
    echo ""
    echo "=== Testing Backup Copy Creation ==="

    local temp_home=$(mktemp -d)
    local temp_project="$temp_home/projects/test-project"
    local temp_stash=$(mktemp -d)
    trap "rm -rf $temp_home $temp_stash" EXIT

    mkdir -p "$temp_project"
    echo "test content v1" > "$temp_project/AGENTS.md"

    export HOME="$temp_home"
    cd "$temp_project"

    echo "Test 5a: Creating first symlink..."
    AGENT_CONFIGS_DIR="$temp_stash" "$BIN_DIR/agent-md" --stash AGENTS.md

    local expected_link="$temp_stash/user/src/projects/test-project/AGENTS.md"
    if [[ -L "$expected_link" ]]; then
        echo "✓ First symlink created"
    else
        echo "✗ First symlink not created"
        return 1
    fi

    echo "Test 5b: Running agent-md --stash again saves numbered backup..."
    echo "test content v2" > "$temp_project/AGENTS.md"
    AGENT_CONFIGS_DIR="$temp_stash" "$BIN_DIR/agent-md" --stash AGENTS.md

    local backup_file="$temp_stash/user/src/projects/test-project/AGENTS.md.1"
    if [[ -f "$backup_file" ]]; then
        if grep -q "test content v2" "$backup_file"; then
            echo "✓ agent-md --stash created numbered backup with current content"
        else
            echo "✗ Backup file doesn't contain expected content"
            return 1
        fi
    else
        echo "✗ Backup file not created at: $backup_file"
        return 1
    fi
}

test_home_relative || exit 1
test_root_relative || exit 1
test_missing_source || exit 1
test_directory_creation || exit 1
test_no_duplicate_symlinks || exit 1

echo ""
echo "All agent-md --stash tests passed!"
