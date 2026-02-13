# Code Style

## Strictness
- Validate at entry points only (APIs, file reads, user input, untrusted data)
  - Use schema libraries (e.g. pydantic) whenever possible
  - When expectations are violated, throw or error, don't log and continue
- Inside the system, assume contracts hold--don't add defensive checks mid-function
- Don't wrap internal calls in try-catch: let exceptions propagate unless you can recover

## Naming
- Prefer conciseness and clarity over verbosity or ambiguity
  - `config` not `configuration`
  - `get_defaults()` not `get_default_values()`
  - don't let verbiage bury math and logic
- Filenames: one word when unambiguous, two only when necessary

## Comments
- Required for: regex patterns, complex recursion, multi-step data transformations
- Avoid: past tense verbs, end-of-line comments, change history
