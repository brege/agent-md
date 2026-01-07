# Code Style

## Strictness
- Validate at entry points only (APIs, file reads, user input, untrusted data)
  - Use schema libraries where applicable
  - Assert that inputs match expected formats
  - When expectations are violated, throw or error, don't log and continue
- Inside the system, assume contracts hold—don't add defensive checks mid-function
- Don't wrap internal calls in try-catch—let exceptions propagate
  - Catch only at boundaries where you can act (request handlers, CLI, retry loops)

## Naming
- Prefer clarity over brevity
  - `config` not `configuration`
  - `get_defaults()` not `get_default_values()`
  - No abbreviations or acronyms: `number` not `num`, `greaterThan` not `gt`
- Filenames: one word when unambiguous, two when necessary

## Comments
- Required for: regex patterns, complex recursion, multi-step data transformations
- Avoid: past tense verbs, end-of-line comments, change history
