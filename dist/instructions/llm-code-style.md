# LLM Code Style

### File Operations

- Prefer editing an existing file to creating a new one
- Never create or proactively edit documentation files (*.md or README) unless explicitly requested
- Only create files when absolutely necessary for achieving the goal
- If code changes contradict existing documentation, propose updates to keep docs in sync rather than silently leaving inconsistencies

### Comments and Code

- Use comments sparingly
- Don't comment out code - remove it instead
- Don't add comments describing the process of changing code
  - Comments should not include past tense verbs like "added", "removed", "changed"
  - Example of what to avoid: `// Changed to handle edge case`
- Don't add comments that emphasize different versions of code
  - Example of what to avoid: `// This code now handles...`
- Avoid end-of-line comments - place comments above the code they describe
- Remove debugging comments before finishing

### Backward Compatibility

- Avoid backward-compatibility hacks
  - Don't rename unused variables with underscores (`_var`)
  - Don't re-export types just to maintain old names
  - Don't add `// removed` comments for deleted code
  - If something is unused, delete it completely
