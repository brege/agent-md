agent-md - Claude + Codex Manager
=================================

Configuration templates and instructions for Claude Code and Codex.

Modeled after `motlin/claude-code-prompts`_ but not as advanced. Also creates an AGENTS.md for Codex.

.. _motlin/claude-code-prompts: https://github.com/motlin/claude-code-prompts/tree/7a68c0f

Installation
------------

.. code-block:: bash

   ./install              # all commands to /usr/local/bin
   ./install --claude     # only claude-md
   ./install --codex      # only codex-md
   ./install --agent      # only agent-md (requires both claude-md and codex-md)
   ./install ~/bin        # custom path in $PATH

This installs commands in your path.

+--------+---------------+-------------------------------------------------------+
| agent  | command       | description                                           |
+========+===============+=======================================================+
| Claude | ``claude-md`` | merges prompts and agents, copies CLAUDE.md and       |
|        |               | settings.json                                         |
+--------+---------------+-------------------------------------------------------+
| Codex  | ``codex-md``  | generates monolithic AGENTS.md from modular sources   |
+--------+---------------+-------------------------------------------------------+
| Agent  | ``agent-md``  | convenience wrapper that runs claude-md then codex-md |
+--------+---------------+-------------------------------------------------------+

Configuration Builders
----------------------

This tool is for those who use both Claude and Codex.

**claude-md**
'''''''''''''

Claude can be configured globally through a central ``CLAUDE.md`` file, and informed locally by an overriding project ``CLAUDE.md`` file, or more commonly a user-specific project ``CLAUDE.local.md`` file. Similarly, a local project specific ``.claude/settings.local.json`` can also be set and is usually managed by Claude. **These *.md files are not adjusted by this tool.**

This tool provides a builder for the global ``CLAUDE.md`` file through a collection of partials.

- copies ``prompts/partials/instructions/`` to ``~/.claude/instructions/``
- copies ``prompts/CLAUDE.md`` to ``~/.claude/CLAUDE.md`` with @instructions references intact
- merges settings from modular JSON files:

  - ``settings/settings.json`` (manifest)
  - ``settings/partials/*.json`` (path/command/etc specific restrictions)
  - ``user/settings/*/**.json`` (appended to the above)

  into ``~/.claude/settings.json`` (deny arrays are deduplicated and merged)

We leave local ``.claude/settings.local.json`` and ``CLAUDE.local.md`` untouched.

.. code-block:: bash
    
   ./install --claude
   claude-md

*reference:* `CLAUDE.md documentation`_

.. _`CLAUDE.md documentation`: https://code.claude.com/docs

**codex-md**
''''''''''''

Codex uses a local, monolithic ``AGENTS.md`` file for each project. In addition, Codex supports an 
``AGENTS.override.md``. We do not "merge" this. Codex will delta the configs by itself. 

**codex-md** will

- expand ``@instructions/*.md`` from:

  - ``prompts/partials/instructions/``
  - ``user/prompts/partials/instructions/``

  and writes ``./AGENTS.md``.

- merge:

  - ``settings/settings.json``
  - ``settings/partials/*.json``
  - **project-local** ``./.claude/settings.json``

  then injects into ``./AGENTS.md``.

If a local ``CLAUDE.local.md`` (or ``.claude/settings.local.json``) file is in the project root, **codex-md** will use them to build the full AGENTS.md file.

.. code-block:: bash
    
   ./install --codex
   codex-md

*reference:* `Codex AGENTS.md documentation`_

.. _`Codex AGENTS.md documentation`: https://developers.openai.com/codex/guides/agents-md

License
-------

Prompts: `CC-BY-SA 4.0`_

Scripts: `GPL-3.0`_

.. _`CC-BY-SA 4.0`: https://creativecommons.org/licenses/by-sa/4.0/

.. _`GPL-3.0`: https://www.gnu.org/licenses/gpl-3.0.html
