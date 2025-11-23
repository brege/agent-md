# File Access Restrictions

Never access personal data directories like SSH keys, credentials, browser profiles, or sensitive user directories. Specific prohibited paths are configured in settings.

## Safe for code and configuration work

Project root and subdirectories, as well as:

- /tmp/
- Code/script directories with explicit user permission
- XDG config directories
- Extensions: .yaml, .yml, .json, .toml, .conf, .ini

@instructions/file-restrictions-allow.md

## Prohibited Directories

Never access the following directories:

- ~/.ssh/
- ~/.gnupg/
- ~/.var/app/

@instructions/file-restrictions-deny.md

