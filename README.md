# Agent Configs

Configuration templates and instructions for Claude Code and Codex agents.

Modeled after [motlin/claude-code-prompts](https://github.com/motlin/claude-code-prompts) with custom rules and agent definitions.

## Installation

- Claude: `./claude-init` - Symlinks instructions and agents, copies CLAUDE.md and settings.json
- Codex: `./codex-init` - Generates monolithic AGENTS.md from modular sources

## Codex AGENTS.md Generation

Codex requires a single monolithic `AGENTS.md`. The builder:

1. Expands all `@instructions/*.md` references from `base-CLAUDE.md`
2. Collects deny rules from `base-settings.json` and modular JSON files in `shared/json/` (git, installers, paths)
3. Merges everything into `base-AGENTS.md` template, creating a complete agent configuration

## Documentation

- [Claude CLAUDE.md](https://code.claude.com/docs)
- [Codex AGENTS.md](https://developers.openai.com/codex/guides/agents-md)

## Structure

- `shared/` - Base configuration templates
  - `json/` - Modular settings for Codex builder (permissions, paths, installers)
- `instructions/` - Instruction files for rules and practices
- `agents/` - Custom agent definitions
- `ref/` - Reference implementations
