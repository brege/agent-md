#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

# Test the core override detection logic
test_override_detection() {
    echo "=== Testing @override Detection Logic ==="

    local test_file=$(mktemp)
    trap "rm -f $test_file" EXIT

    # Test 1: File with @override marker
    echo "Test 1a: Checking for @override marker in file..."
    cat > "$test_file" << 'EOF'
@override
# Code Style
Replacement content
EOF

    echo "  File content:"
    head -1 "$test_file" | sed 's/^/    /'

    if head -1 "$test_file" | grep -q "^@override"; then
        echo "✓ @override detection works"
    else
        echo "✗ @override detection failed"
        return 1
    fi

    # Test 2: File without @override marker
    echo "Test 1b: Checking file without @override marker..."
    cat > "$test_file" << 'EOF'
# Code Style
Regular content
EOF

    echo "  File content:"
    head -1 "$test_file" | sed 's/^/    /'

    if ! head -1 "$test_file" | grep -q "^@override"; then
        echo "✓ Non-override detection works"
    else
        echo "✗ Non-override detection failed"
        return 1
    fi

    # Test 3: Stripping @override marker
    echo "Test 1c: Stripping @override marker..."
    cat > "$test_file" << 'EOF'
@override
# Code Style
Replacement content
EOF

    echo "  Original content:"
    cat "$test_file" | sed 's/^/    /'

    local content=$(tail -n +2 "$test_file")

    echo "  After stripping line 1:"
    echo "$content" | sed 's/^/    /'

    if echo "$content" | grep -q "# Code Style"; then
        echo "✓ @override marker stripping works"
    else
        echo "✗ @override marker stripping failed"
        return 1
    fi

    if ! echo "$content" | grep -q "^@override"; then
        echo "✓ Marker removed from output"
    else
        echo "✗ Marker not removed"
        return 1
    fi
}

# Test append mode logic
test_append_logic() {
    echo ""
    echo "=== Testing Append Mode Logic ==="

    local base=$(mktemp)
    local local=$(mktemp)
    local output=$(mktemp)
    trap "rm -f $base $local $output" EXIT

    echo "Test 2a: Combining base and local files..."
    cat > "$base" << 'EOF'
# Code Style

Base content here.
EOF

    cat > "$local" << 'EOF'
User additions here.
EOF

    echo "  Base file:"
    cat "$base" | sed 's/^/    /'
    echo "  Local file:"
    cat "$local" | sed 's/^/    /'

    {
        cat "$base"
        echo ""
        cat "$local"
    } > "$output"

    echo "  Combined output:"
    cat "$output" | sed 's/^/    /'

    local content=$(cat "$output")
    if echo "$content" | grep -q "Base content here."; then
        echo "✓ Base content present"
    else
        echo "✗ Base content missing"
        return 1
    fi

    if echo "$content" | grep -q "User additions here."; then
        echo "✓ Local content present"
    else
        echo "✗ Local content missing"
        return 1
    fi

    if [[ $(grep -c "^" "$output") -ge 4 ]]; then
        echo "✓ Both contents combined"
    else
        echo "✗ Contents not properly combined"
        return 1
    fi
}

# Test override mode logic
test_override_logic() {
    echo ""
    echo "=== Testing Override Mode Logic ==="

    local base=$(mktemp)
    local local=$(mktemp)
    local output=$(mktemp)
    trap "rm -f $base $local $output" EXIT

    echo "Test 3a: Override mode - local replaces base..."
    cat > "$base" << 'EOF'
# Code Style

Base content here.
EOF

    cat > "$local" << 'EOF'
@override
# Code Style Override

Replacement content here.
EOF

    echo "  Base file:"
    cat "$base" | sed 's/^/    /'
    echo "  Local file (with @override):"
    cat "$local" | sed 's/^/    /'

    echo "  First line of local:"
    head -1 "$local" | sed 's/^/    /'

    # Simulate override logic
    if head -1 "$local" | grep -q "^@override"; then
        echo "  @override marker detected - using local only (skipping line 1)"
        tail -n +2 "$local" > "$output"
    else
        echo "  No @override marker - using base"
        cat "$base" > "$output"
    fi

    echo "  Final output:"
    cat "$output" | sed 's/^/    /'

    local content=$(cat "$output")
    if ! echo "$content" | grep -q "Base content here."; then
        echo "✓ Base content correctly excluded"
    else
        echo "✗ Base content should not be present"
        return 1
    fi

    if echo "$content" | grep -q "Replacement content here."; then
        echo "✓ Override content present"
    else
        echo "✗ Override content missing"
        return 1
    fi

    if ! echo "$content" | grep -q "^@override"; then
        echo "✓ @override marker stripped"
    else
        echo "✗ @override marker should be stripped"
        return 1
    fi
}

test_override_detection || exit 1
test_append_logic || exit 1
test_override_logic || exit 1

echo ""
echo "All logic tests passed!"
