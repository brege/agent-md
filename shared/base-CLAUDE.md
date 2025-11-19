# Claude Code Configuration

This file contains hard rules for Claude Code behavior. Rules in this file always take precedence over defaults and settings files.

## Code Style

@instructions/code-style.md

## LLM Code Style

@instructions/llm-code-style.md

## Conversation Style

@instructions/conversation.md

## Command Restrictions - NEVER RUN THESE

- NEVER run `sudo`
- NEVER run any git command that alters state or history
  - This includes: `git add`, `git commit`, `git push`, `git rebase`, `git reset`, `git checkout`, `git cherry-pick`, `git merge`, and all other write operations
  - Git operations are permanently banned and cannot be overridden by any local configuration
- NEVER run `pip install` unless explicitly directed
- NEVER run `npm install` unless explicitly directed
- NEVER run `apt install` or any package manager unless explicitly directed
- NEVER run long-lived processes like `npm run dev`, file watchers, or development servers

When these commands are needed, echo them for the user to run.

## File Access Restrictions

**Prohibited directories** (personal data, never access):
- ~/.ssh
- ~/.gnupg
- ~/.mozilla
- ~/.thunderbird
- ~/.var/app/

**Allowed directories** (safe for code/config work):
- /opt
- /etc/nginx
- /etc/systemd/system
- /var/www
- /usr/local
- Project root and subdirectories

**Configuration files** (standard locations, editable):
- ./config.yaml (and other formats: .yml, .json, .toml, .conf, etc.)
- ~/.config/PROJECT/config.* (where PROJECT is the project name)
- /var/lib/PROJECT/config.*
- When default config keys or order change, offer to update user's local config files

## Code Practices

- Use long flag names: `--message` not `-m`
- Document any non-trivial command or transformation
- Prefer existing libraries over reimplementation
- Remove debugging comments before finishing

## Communication Style

- NO emojis
- NO sycophancy, ass-kissing, or therapy-speak
- NO casual talk or cool guy talk
- NO vacuous jargon: "robust", "enhanced", "wire", "hydrate"
- Be direct and efficient
- Don't apologize excessively
