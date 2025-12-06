agent-md · interagent config manager 
====================================

Configuration templates and instructions for Claude Code and Codex cohabitation. **This tool is for those who use both.**

This tool creates a CLAUDE.md and settings.json for Claude Code and a monolithic AGENTS.md for Codex. This allows you to centralize configuration for the two agents in one place.

Then, to distribute the agent configurations, run

.. code-block:: bash 
    
    agent-md

in your project directory. Local project files like

- ``./CLAUDE.md``
- ``./CLAUDE.local.md``
- ``./.claude/settings.local.json``
- ``AGENTS.override.md``

are not effected. These may be symlinked to ``user/``, where you may place all of your customizations, via ``agent-md --stash``. This schema allows appending or overriding the distribution prompts, ``dist/**/*.md``,
through ``user/**.*.md``. The top-level authority is local > ``user`` > ``dist`` > system.

Installation
------------

.. code-block:: bash

   ./install              # all commands to /usr/local/bin
   ./install --claude     # only claude-md
   ./install --codex      # only codex-md
   ./install ~/bin        # custom path in $PATH, defaults to /usr/local/bin

This installs commands in your path.

+--------+--------------------+-------------------------------------------------------+
| agent  | command            | description                                           |
+========+====================+=======================================================+
| Claude | ``claude-md``      | merges prompts and agents, copies CLAUDE.md and       |
|        |                    | settings.json                                         |
+--------+--------------------+-------------------------------------------------------+
| Codex  | ``codex-md``       | generates monolithic AGENTS.md from modular sources   |
+--------+--------------------+-------------------------------------------------------+
| Agent  | ``agent-md``       | runs claude-md then codex-md                          |
+--------+--------------------+-------------------------------------------------------+

Configuration Builders
----------------------


**claude-md**
'''''''''''''

Claude can be configured globally through a central ``CLAUDE.md`` file, and informed locally by an overriding project ``CLAUDE.md`` file, or more commonly a user-specific project ``CLAUDE.local.md`` file. Similarly, a local project specific ``.claude/settings.local.json`` can also be set and is usually managed by Claude. **These *.md files are not adjusted by this tool.**

This tool provides a builder for the global ``CLAUDE.md`` file through a collection of partials.

- copies ``dist/instructions/`` to ``~/.claude/instructions/``
- copies ``dist/CLAUDE.md`` to ``~/.claude/CLAUDE.md`` with @instructions references intact
- merges settings from modular JSON files:

  - ``dist/settings.json``
  - ``dist/settings/*.json`` (security-paths, git, installers, system-paths)
  - ``user/settings/*.json``

  into ``~/.claude/settings.json``

We leave local ``.claude/settings.local.json`` and ``CLAUDE.local.md`` untouched.

User Override Mode
~~~~~~~~~~~~~~~~~~~

To use only custom settings without merging distribution defaults, set ``"override": true`` in ``user/settings.json``. The override key does not transfer to ``~/.claude/settings.json``.

.. code-block:: bash

   ./install --claude
   claude-md

*reference:* `CLAUDE.md documentation`_

.. _`CLAUDE.md documentation`: https://code.claude.com/docs

**codex-md**
''''''''''''

Codex uses a local monolithic ``AGENTS.md`` file for each project. Codex supports ``AGENTS.override.md`` which it diffs directly—we do not merge this.

**codex-md** will

- expand ``@instructions/*.md`` from:

  - ``dist/instructions/``
  - ``user/instructions/``

  then write ``./AGENTS.md``

- merge deny arrays from:

  - ``dist/settings.json``
  - ``dist/settings/*.json``
  - ``user/settings/*.json``
  - ``./.claude/settings.json`` (project-local, if exists)

  then inject into ``./AGENTS.md``

If a local ``CLAUDE.local.md`` or ``./.claude/settings.json`` exists in the project root, **codex-md** uses them to build the full AGENTS.md file.

.. code-block:: bash
    
   ./install --codex
   codex-md

*reference:* `Codex AGENTS.md documentation`_

.. _`Codex AGENTS.md documentation`: https://developers.openai.com/codex/guides/agents-md

**agent-md**
''''''''''''

If you do use both agents, you can run **agent-md** in your project to generate the configuration files for **codex-md** and **claude-md**:

.. code-block:: bash

   ./install
   agent-md

This will generate ``~/.claude/CLAUDE.md``, ``~/.claude/settings.json`` and ``./AGENTS.md``. Use ``agent-md --stash`` to symlink and store versions of your **local** configuration files (``./CLAUDE.local.md``,  ``./.claude/settings.local.json``, ``AGENTS.override.md``) in ``user/src/``.

License
-------

Prompts: `CC-BY-SA 4.0`_

Scripts: `GPL-3.0`_

.. _`CC-BY-SA 4.0`: https://creativecommons.org/licenses/by-sa/4.0/

.. _`GPL-3.0`: https://www.gnu.org/licenses/gpl-3.0.html
