Agent Configs
=============

Configuration templates and instructions for Claude Code and Codex.

Modeled after `motlin/claude-code-prompts`_ but not as advanced. Also creates an AGENTS.md for Codex.

This tool is for those who use both.

.. _motlin/claude-code-prompts: https://github.com/motlin/claude-code-prompts

Installation
------------

.. code-block:: bash

   ./install              # both to /usr/local/bin
   ./install --claude     # only claude-md
   ./install --codex      # only codex-md
   ./install ~/bin        # some custom path in $PATH

This installs two commands in your path.

+--------+---------------+-------------------------------------------------------+
| agent  | command       | description                                           |
+========+===============+=======================================================+
| Claude | ``claude-md`` | merges instructions and agents, copies CLAUDE.md and  |
|        |               | settings.json                                         |
+--------+---------------+-------------------------------------------------------+
| Codex  | ``codex-md``  | generates monolithic AGENTS.md from modular sources   |
+--------+---------------+-------------------------------------------------------+

Configuration Builders
----------------------

**claude-md** script

Claude can be configured globally through a central ``CLAUDE.md`` file, and informed locally by an overriding ``CLAUDE.md`` file, or more commonly a project-specific ``CLAUDE.local.md`` file. Similarly, a local project specific ``.claude/settings.local.json`` can also be set.

This tool does not touch ``CLAUDE.local.md`` files. What it does is build the global ``CLAUDE.md`` file.

- copies ``prompts/partials/instructions/`` (and ``agents/``, etc.) to ``~/.claude/``
- copies ``prompts/CLAUDE.md`` to ``~/.claude/CLAUDE.md``, preserving ``@instructions/*.md`` anchors
- merges ``settings/settings.json`` and ``settings/partials/*.json`` → ``~/.claude/settings.json``

*reference:* `CLAUDE.md documentation`_

.. _`CLAUDE.md documentation`: https://code.claude.com/docs

**codex-md** script

Codex uses a local, monolithic ``AGENTS.md`` file for each project. In addition, Codex supports a AGENTS.override.md. We do not "merge" this. Codex will delta the configs by itself.

- expands ``@instructions/*.md`` from:

  - ``prompts/partials/``
  - ``local/prompts/partials/``

  and writes ``./AGENTS.md``.

- merges:

  - ``settings/settings.json``
  - ``settings/partials/*.json``
  - **project-local** ``./.claude/settings.json``

  then injects into ``AGENTS.md``.

If a local ``CLAUDE.local.md`` (or ``.claude/settings.local.json``) file is in the project root, ``codex-md`` will use them to build the full AGENTS.md file.

*reference:* `Codex AGENTS.md documentation`_

.. _`Codex AGENTS.md documentation`: https://developers.openai.com/codex/guides/agents-md

License
-------

Prompts: `CC-BY-SA 4.0`_

Scripts: `GPL-3.0`_

.. _`CC-BY-SA 4.0`: https://creativecommons.org/licenses/by-sa/4.0/

.. _`GPL-3.0`: https://www.gnu.org/licenses/gpl-3.0.html
