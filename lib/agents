#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Merge and copy agent files with user augmentation

set -euo pipefail

REPO_DIR="${1:?REPO_DIR required}"
CLAUDE_DIR="${2:?CLAUDE_DIR required}"

if [[ -d "$REPO_DIR/dist/agents" ]]; then
    while IFS= read -r src_file; do
        filename=$(basename "$src_file")
        dest_file="$CLAUDE_DIR/agents/$filename"
        user_file="$REPO_DIR/user/agents/$filename"

        if [[ -f "$user_file" ]] && head -1 "$user_file" | grep -q "^@override"; then
            tail -n +2 "$user_file" > "$dest_file"
        else
            {
                cat "$src_file"
                if [[ -f "$user_file" ]]; then
                    echo ""
                    cat "$user_file"
                fi
            } > "$dest_file"
        fi
    done < <(find "$REPO_DIR/dist/agents" -maxdepth 1 -type f -name "*.md")
fi
