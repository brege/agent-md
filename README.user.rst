agent-md - User Configurations
===================

User-defined customizations, extensions, and project-specific configurations.

Structure
---------

.. code-block:: text

   user/
   ├── README.rst            symlink to ../README.user.rst
   ├── agents/               custom agent partials
   ├── instructions/         custom instruction partials
   ├── settings/             custom settings fragments
   └── src/
       ├── path/from/home/   stashed project configs
       └── _/path/from/root/ stashed project configs

Usage
-----

**Extend prompts and settings**
   Place custom partials in ``instructions/`` (and ``agents/`` if needed) plus JSON fragments in ``settings/`` following the same structure as the distribution files under ``dist/``. The build tools append them to the base versions.

   To completely replace a base partial instead of appending, start your file with ``@override`` on the first line:

   .. code-block:: bash

      user/instructions/file-restrictions.md
      @override
      # File Access Restrictions
      (replacement content)

**Track project configurations**
   Use ``stash-md`` to symlink project-specific files:

   .. code-block:: bash

      cd /path/to/your/project
      stash-md CLAUDE.local.md
      stash-md AGENTS.override.md

   This creates symlinks preserving the full directory structure:

   - Home paths: ``src/path/to/your/project/CLAUDE.local.md``
   - Root paths: ``src/_/path/to/your/project/AGENTS.override.md``

Repository
----------

Initialize this directory as your own git repository to track your customizations:

.. code-block:: bash

   cd user/ && git init
