agent-md - User Configurations
===================

User-defined customizations, extensions, and project-specific configurations.

Structure
---------

.. code-block:: text

   user/
   ├── README.rst              symlink to ../README.user.rst
   ├── prompts/
   │   └── partials/
   │       └── instructions/   custom instruction partials
   ├── settings/
   │   └── partials/           custom settings partials
   └── src/
       ├── path/from/home/     stashed project configs
       └── _/path/from/root/   stashed project configs

Usage
-----

**Extend prompts and settings**
   Place custom partials in ``prompts/partials/instructions/`` and ``settings/partials/`` following the same structure as the base project. The build tools will automatically append them to the base versions.

   To completely replace a base partial instead of appending, start your file with ``@override`` on the first line:

   .. code-block:: bash

      user/prompts/partials/instructions/file-restrictions.md
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
