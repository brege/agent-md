#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Merge and copy settings.json

set -euo pipefail

REPO_DIR="${1:?REPO_DIR required}"
CLAUDE_DIR="${2:?CLAUDE_DIR required}"

dest="$CLAUDE_DIR/settings.json"

if [[ -f "$REPO_DIR/user/settings/settings.json" ]] && jq -e '.override == true' "$REPO_DIR/user/settings/settings.json" >/dev/null 2>&1; then
    jq 'del(.override)' "$REPO_DIR/user/settings/settings.json" > "$dest"
    echo "updated: settings.json (override)"
else
    {
        jq -s '.[0] as $base | {
          includeCoAuthoredBy: $base.includeCoAuthoredBy,
          permissions: {
            deny: ([.[].permissions.deny // []] | add)
          },
          model: $base.model,
          alwaysThinkingEnabled: $base.alwaysThinkingEnabled
        }' "$REPO_DIR/settings/settings.json" "$REPO_DIR/settings/partials"/*.json "$REPO_DIR/user/settings/partials"/*.json 2>/dev/null || cat "$REPO_DIR/settings/settings.json"
    } > "$dest"
    echo "updated: settings.json"
fi
