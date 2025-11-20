# File Access Restrictions

Never access personal data directories like SSH keys, credentials, browser profiles, or sensitive user directories. Specific prohibited paths are configured in settings.

Safe for code and configuration work:
- Project root and subdirectories
- Standard system directories: /opt, /var/www, /usr/local, /etc
- Code/script directories with explicit user permission

Editable configuration files:
- ./config.yaml (and other formats: .yml, .json, .toml, .conf, etc.)
- ~/.config/PROJECT/config.* (where PROJECT is the project name)
- /var/lib/PROJECT/config.*

When default config keys or order change, offer to update user's local config files.
