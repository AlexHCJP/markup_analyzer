# MarkupAnalyzer Lint Rule

![Pub Version](https://img.shields.io/pub/v/markup_analyzer)
![License](https://img.shields.io/github/license/AlexHCJP/markup_analyzer)
![Issues](https://img.shields.io/github/issues/AlexHCJP/markup_analyzer)
![Stars](https://img.shields.io/github/stars/AlexHCJP/markup_analyzer)

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

Add the plugin to your `analysis_options.yaml`. No changes to `pubspec.yaml` required:

```yaml
plugins:
  markup_analyzer:
    diagnostics:
      simple_string: error
      string_interpolation: error
      binary_expression: warning
      adjacent_strings: warning
      method_invocation: warning
      simple_identifier: none
      prefixed_identifier: none
      function_invocation: none
```

## Configuration

Each diagnostic can be set to `error`, `warning`, `info`, or `none` (disabled):

| Code | Default |
|------|---------|
| `simple_string` | `error` |
| `string_interpolation` | `error` |
| `binary_expression` | `warning` |
| `adjacent_strings` | `warning` |
| `method_invocation` | `warning` |
| `simple_identifier` | `none` |
| `prefixed_identifier` | `none` |
| `function_invocation` | `none` |

## Diagnostics

| Code | Description |
|------|-------------|
| `simple_string` | Simple string literal passed to a widget |
| `string_interpolation` | String interpolation passed to a widget |
| `adjacent_strings` | Adjacent string literals passed to a widget |
| `binary_expression` | Binary string expression (e.g. `'a' + 'b'`) passed to a widget |
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

```dart
// BAD
Text('Hello, ' + 'world!');
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
