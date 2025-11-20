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

| agent  | command     | description |
|:-------|:------------|:------------|
| Claude | `claude-md` | Symlinks instructions and agents, copies CLAUDE.md and settings.json |
| Codex  | `codex-md`  | Generates monolithic AGENTS.md from modular sources |

## Configuration Builders

**claude-md**

- symlinks `instructions/` and `agents/` to local `~/.claude`
- copies `base-CLAUDE.md` to `~/.claude/CLAUDE.md`
- merges `shared/json/*.json` and `base-settings.json` into `~/.claude/settings.json`

reference: [CLAUDE.md documentation](https://code.claude.com/docs)

**codex-md:** - monolithic `AGENTS.md`

1. injects `@instructions/*.md` into `base-CLAUDE.md`, then writes `./AGENTS.md` in current directory

2. merges

   - `base-settings.json`
   - `shared/json/*.json`
   - `./.claude/settings.json`  

   then injects into `AGENTS.md`

reference: [Codex AGENTS.md documentation](https://developers.openai.com/codex/guides/agents-md)


## License

[CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)

