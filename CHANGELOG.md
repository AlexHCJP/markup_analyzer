## 4.1.0

- New rule `binary_string_literal`: reports the raw literals **inside** a binary expression rather than the expression itself. `'Hello, ' + name` and `title ?? 'Untitled'` report at the literal; `label ?? l10n.fallback` and `name ?? ''` report nothing. `binary_expression` is unchanged — enable one, the other, or both
- Installation docs: the `plugins:` entry needs a source (`version:`, `path:`, `git:`) — without one the analyzer loads no plugin and reports nothing

## 4.0.3

- Readme

## 4.0.2

- Update analyzer and analysis_server_plugin

## 4.0.1

- Split into 8 independent lint rules — each can be enabled/disabled separately in `analysis_options.yaml`

## 4.0.0

- **Breaking:** migrated from `custom_lint` to native `analysis_server_plugin` — no longer requires `custom_lint` dependency
- Checks are now scoped to Flutter widget constructors only (ignores non-widget calls)
- Type-aware analysis: only flags expressions that actually return `String`
- Severity and enable/disable per-diagnostic configured via `analysis_options.yaml`
- Minimum Dart SDK bumped to `3.11.0`

## 1.0.0

- Initial version.

## 1.0.1

- add work with directories, update README.md and terminal output user-friendly

## 1.0.2

- add exception handling for file reading

## 1.0.3

- rename packet from test_localization to markup_analyzer

## 1.0.4

- change ReadMe.md

## 2.0.0

- Markup Analyzer its lint

## 3.0.6

- Refactoring, change version custom_lint

## 3.0.7

- Update custom_lint 

## 3.0.8

- resolve version packages