# Command Restrictions

These commands must NEVER be run:

- `sudo`
- Any git command that alters state or history
  - `git add`, `git commit`, `git push`, `git rebase`, `git reset`, `git checkout`, `git cherry-pick`, `git merge`, and all other write operations
  - Git operations are permanently banned and cannot be overridden by any local configuration
- `pip install` unless explicitly directed
- `npm install` unless explicitly directed
- `apt install` or any package manager unless explicitly directed
- `dnf install` or any package manager unless explicitly directed
- Long-lived processes like `npm run dev`, file watchers, or development servers

When these commands are needed, echo them for the user to run.
