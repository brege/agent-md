# Code Style

## Strictness

- Don't write forgiving code
  - Don't permit multiple input formats
  - Use preconditions
    - Use schema libraries where applicable
    - Assert that inputs match expected formats
    - When expectations are violated, throw or error, don't log and continue
  - Don't add defensive try/catch blocks
    - Usually let exceptions propagate

## Naming

- Don't use abbreviations or acronyms
  - Choose `number` instead of `num`
  - Choose `greaterThan` instead of `gt`
  - Choose complete words in variable and function names

## Comments

- Comments are allowed but should be minimal
- Don't comment out code - remove it instead
- Don't add comments describing the process of changing code
  - Comments should not include past tense verbs like "added", "removed", "changed"
  - Example of what to avoid: `this.timeout(10_000); // Increased timeout for API calls`
- Don't emphasize different versions of code with phrases like "this code now handles"
- Avoid end-of-line comments - place comments above the code they describe
