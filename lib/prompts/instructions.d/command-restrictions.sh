#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Generate command-restrictions.md from settings.json deny rules

set -euo pipefail

REPO_DIR="${1:?REPO_DIR required}"
CLAUDE_DIR="${2:?CLAUDE_DIR required}"

dest="$CLAUDE_DIR/settings.json"

{
    echo "# Command Restrictions"
    echo ""
    jq -r '.permissions.deny[]' "$dest" | sort -u | while read -r rule; do
        case "$rule" in
            Bash\(*) cmd="${rule#Bash(}"; cmd="${cmd%:*)}"; echo "- Never run '$cmd' or any command matching it." ;;
            Read\(*) path="${rule#Read(}"; path="${path%)}"; echo "- Never read files matching $path." ;;
            Edit\(*) path="${rule#Edit(}"; path="${path%)}"; echo "- Never edit files matching $path." ;;
            Write\(*) path="${rule#Write(}"; path="${path%)}"; echo "- Never write to files matching $path." ;;
            Glob\(*) path="${rule#Glob(}"; path="${path%)}"; echo "- Never enumerate file paths matching $path." ;;
            *) echo "- Deny: $rule" ;;
        esac
    done
    if [[ -f "$REPO_DIR/user/instructions/command-restrictions.md" ]]; then
        echo ""
        cat "$REPO_DIR/user/instructions/command-restrictions.md"
    fi
} > "$CLAUDE_DIR/instructions/command-restrictions.md"
