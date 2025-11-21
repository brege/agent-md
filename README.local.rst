Local Configurations
====================

User-defined customizations, extensions, and project-specific configurations.

Structure
---------

.. code-block:: text

   local/
   ├── README.rst              symlink to ../README.local.rst
   ├── prompts/
   │   └── partials/
   │       └── instructions/   custom instruction partials
   ├── settings/
   │   └── partials/           custom settings partials
   └── src/
       └── path/from/root/     stashed project configs

Usage
-----

**Extend prompts and settings**
   Place custom partials in ``prompts/partials/instructions/`` and ``settings/partials/`` following the same structure as the base project. The build tools will automatically append them to the base versions.

   To completely replace a base partial instead of appending, start your file with ``@override`` on the first line:

   .. code-block:: bash

      local/prompts/partials/instructions/file-restrictions.md
      @override
      # File Access Restrictions
      (replacement content)

**Track project configurations**
   Use ``stash-md`` to symlink project-specific files:

   .. code-block:: bash

      cd /path/to/your/project
      stash-md CLAUDE.local.md
      stash-md AGENTS.override.md

   This creates symlinks in ``src/code/`` following the pattern:

   - ``src/code/{project}.CLAUDE.local.md`` → ``/path/to/project/CLAUDE.local.md``
   - ``src/code/{project}.AGENTS.override.md`` → ``/path/to/project/AGENTS.override.md``

Repository
----------

Initialize this directory as your own git repository to track your customizations:

.. code-block:: bash

   cd local/
   git init
