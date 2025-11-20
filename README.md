# Agent Configs

Configuration templates and instructions for Claude Code and Codex.

Modeled after [motlin/claude-code-prompts](https://github.com/motlin/claude-code-prompts) but not as advanced, but also creates an AGENTS.md for Codex.

## Installation

```bash
./install              # both to /usr/local/bin
./install --claude     # only claude-md
./install --codex      # only codex-md
./install ~/bin        # some custom path in $PATH
```

| agent  | command    | description |
|:-------|:-----------|:------------|
| Claude | `claude-md`| Symlinks instructions and agents, copies CLAUDE.md and settings.json |
| Codex  | `codex-md` | Generates monolithic AGENTS.md from modular sources |

## Configuration Builders

**claude-md:** Symlinks `instructions/` and `agents/`, copies `base-CLAUDE.md` and `base-settings.json` to `~/.claude`. Claude manages local customizations in `~/.claude/settings.json`.

**codex-md:** Generates monolithic `AGENTS.md` by:
1. Expanding `@instructions/*.md` references from `base-CLAUDE.md`
2. Collecting deny rules from `base-settings.json` and all `.json` files in `shared/json/`
3. Merging local `.claude/settings.local.json` if present
4. Creating complete agent configuration

## Documentation

- [Claude CLAUDE.md](https://code.claude.com/docs)
- [Codex AGENTS.md](https://developers.openai.com/codex/guides/agents-md)

## Structure

- `shared/` - Base configuration templates
  - `json/` - Modular settings for Codex builder (permissions, paths, installers)
- `instructions/` - Instruction files for rules and practices
- `agents/` - Custom agent definitions
- `ref/` - Reference implementations
