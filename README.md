# MarkupAnalyzer Lint Rule

<div align="center">
  <a href="https://pub.dev/packages/markup_analyzer">
    <img src="https://img.shields.io/pub/v/markup_analyzer?label=Pub&logo=dart" alt="Pub Package" />
  </a>
  <a href="https://pub.dev/packages/markup_analyzer">
    <img src="https://img.shields.io/pub/likes/markup_analyzer?style=flat&logo=dart&label=Likes" alt="Pub Likes" />
  </a>
  <a href="https://pub.dev/packages/markup_analyzer/score">
    <img src="https://img.shields.io/pub/points/markup_analyzer?label=Score&logo=dart" alt="Pub Score" />
  </a>
  <a href="https://pub.dev/packages/markup_analyzer">
    <img src="https://img.shields.io/pub/dm/markup_analyzer?style=flat&color=blue&logo=dart&label=Downloads" alt="Pub Monthly Downloads" />
  </a>
  <a href="https://github.com/AlexHCJP/markup_analyzer">
    <img src="https://img.shields.io/github/stars/AlexHCJP/markup_analyzer?style=flat&logo=github&colorB=deeppink&label=Stars" alt="Star on Github" />
  </a>
  <a href="https://github.com/AlexHCJP/markup_analyzer">
    <img src="https://img.shields.io/github/forks/AlexHCJP/markup_analyzer?color=orange&label=Forks&logo=github" alt="Forks on Github" />
  </a>
  <a href="https://github.com/AlexHCJP/markup_analyzer/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/AlexHCJP/markup_analyzer?style=flat&logo=github&colorB=yellow&label=Contributors" alt="Contributors" />
  </a>
  <a href="https://github.com/AlexHCJP/markup_analyzer/issues">
    <img src="https://img.shields.io/github/issues/AlexHCJP/markup_analyzer?label=Issues&logo=github&color=purple" alt="Issues" />
  </a>
  <a href="https://github.com/AlexHCJP/markup_analyzer/actions/workflows/checkout.yml">
    <img src="https://github.com/AlexHCJP/markup_analyzer/actions/workflows/checkout.yml/badge.svg" alt="Build Status" />
  </a>
  <a href="https://github.com/AlexHCJP/markup_analyzer">
    <img src="https://img.shields.io/github/languages/code-size/AlexHCJP/markup_analyzer?logo=github&color=blue&label=Size" alt="Code size" />
  </a>
  <a href="https://github.com/AlexHCJP/markup_analyzer/blob/HEAD/LICENSE">
    <img src="https://img.shields.io/github/license/AlexHCJP/markup_analyzer?label=License&color=red&logo=Leanpub" alt="License" />
  </a>
  <a href="https://pub.dev/packages/markup_analyzer">
    <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue.svg?logo=flutter" alt="Platform" />
  </a>
</div>

<p align="center">
  <img src="pictures/contributors.png" alt="MarkupAnalyzer logo" width="200"/>
</p>

## Description

`Markup Analyzer` is a native Dart analyzer plugin that enforces localization in Flutter widgets. It flags raw string expressions passed to widget constructors, encouraging the use of localized strings instead.

The plugin uses the built-in `analysis_server_plugin` — no additional tools required.


- [Installation](#installation)
- [Configuration](#configuration)
- [Diagnostics](#diagnostics)
- [Examples](#examples)

## Installation

Add the plugin to your `analysis_options.yaml`. No changes to `pubspec.yaml` required —
but the entry **must** carry a source, otherwise the analyzer parses the block, finds
nothing to resolve, and silently loads no plugin at all (no error, just zero diagnostics):

```yaml
plugins:
  markup_analyzer:
    version: ^4.1.0
    diagnostics:
      simple_string: error
      string_interpolation: error
      adjacent_strings: error
      binary_expression: false
      binary_string_literal: error
      prefixed_identifier: error
      method_invocation: error
      simple_identifier: false
      function_invocation: false
```

Any of pub's source formats works in place of `version`:

```yaml
plugins:
  # From pub.dev.
  markup_analyzer: ^4.1.0

  # From another host.
  markup_analyzer:
    version: ^4.1.0
    hosted: https://my-pub-host.dev

  # From git.
  markup_analyzer:
    git:
      url: https://github.com/AlexHCJP/markup_analyzer.git
      ref: main

  # From a local checkout.
  markup_analyzer:
    path: ../markup_analyzer
```

The short `markup_analyzer: ^4.1.0` form takes no `diagnostics:` block — use the nested
form whenever you want to configure severities.

Verify the plugin is live by running `dart analyze` **from the package root**, with no
target. Passing a subdirectory (`dart analyze lib`) makes that directory the analysis
context root; with no `pubspec.yaml` there the plugin cannot be resolved, and the run
reports "No issues found" even where the plugin would fire.

## Configuration

Each rule is configured independently under `plugins: markup_analyzer: diagnostics:`.

Set severity to `error`, `warning`, or `info` to enable. Set to `false` to disable entirely.

| Code | Description | Suggested severity |
|------|-------------|--------------------|
| `simple_string` | Simple string literal | `error` |
| `string_interpolation` | String interpolation | `error` |
| `adjacent_strings` | Adjacent string literals | `error` |
| `binary_expression` | Binary string expression | `false` |
| `binary_string_literal` | Raw string inside a binary expression | `error` |
| `prefixed_identifier` | Prefixed `String` (e.g. `widget.title`) | `warning` |
| `method_invocation` | `String`-returning method call | `warning` |
| `simple_identifier` | `String` variable | `false` |
| `function_invocation` | `String`-returning function expression | `false` |

## Diagnostics

| Code | Description |
|------|-------------|
| `simple_string` | Simple string literal passed to a widget |
| `string_interpolation` | String interpolation passed to a widget |
| `adjacent_strings` | Adjacent string literals passed to a widget |
| `binary_expression` | Binary string expression (e.g. `'a' + 'b'`) passed to a widget, whatever its operands are |
| `binary_string_literal` | Raw string reached through a binary expression (e.g. `'a' + b`, `a ?? 'b'`) passed to a widget |
| `prefixed_identifier` | Prefixed identifier of type `String` (e.g. `widget.title`) passed to a widget |
| `method_invocation` | Method call returning `String` (e.g. `'x'.tr()`) passed to a widget |
| `simple_identifier` | Variable of type `String` passed to a widget |
| `function_invocation` | Function expression returning `String` passed to a widget |

All checks are **widget-scoped**: only constructor calls of classes that extend `Widget` are analyzed.

## Examples

### Simple string literal

```dart
// BAD
Text('Hello, world!');

// GOOD
Text(AppLocalizations.of(context).greeting);
```

### String interpolation

```dart
// BAD
Text('Hello, $name!');

// GOOD
Text(AppLocalizations.of(context).helloWithName(name));
```

### Adjacent strings

```dart
// BAD
Text(
  'Hello, '
  'world!',
);
```

### Binary expression

`binary_expression` flags the expression itself, operands unread.

```dart
// BAD
Text('Hello, ' + 'world!');
Text(label ?? l10n.fallback);
```

### Binary string literal

`binary_string_literal` flags the literal instead, and only when there is text
in it. Every other rule looks at the argument itself, so a literal one operator
deep passes all of them — this is how they reach it.

Enable it and disable `binary_expression` to require localization without
calling `??` a mistake; enable both to forbid the operator outright.

```dart
// BAD
Text('Hello, ' + name);
Text(title ?? 'Untitled');
Text(title ?? name ?? 'Untitled');

// GOOD
Text(label ?? l10n.fallback);
Text(name ?? '');
```

### Prefixed identifier

```dart
// BAD
Text(widget.title);
```

### Method invocation

```dart
// BAD
Text('hello'.tr());

// GOOD
Text(AppLocalizations.of(context).hello);
```

### Simple identifier

```dart
// BAD
final String title = 'Hello';
Text(title);
```

### Function invocation

```dart
// BAD
Text((() => 'Hello')());
```
