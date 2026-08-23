# Agent Instructions

## Skill Guidelines

- When creating commits, use the `commit-message` skill.

## Documentation Guidelines

- Keep `README.md` and `README.*.md` in the same directory synchronized.
- When synchronizing localized READMEs, translation may be skipped for content matching these patterns:

  ````regex
  ```[\s\S]*?```
  <details>\s*<summary>Links</summary>[\s\S]*?</details>
  ````
