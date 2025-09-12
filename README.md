# MarkupAnalyzer Lint Rule

![Pub Version](https://img.shields.io/pub/v/markup_analyzer)
![License](https://img.shields.io/github/license/AlexHCJP/markup_analyzer)
![Issues](https://img.shields.io/github/issues/AlexHCJP/markup_analyzer)
[![codecov](https://codecov.io/gh/AlexHCJP/markup_analyzer/graph/badge.svg?token=UYEMR670IR)](https://codecov.io/gh/AlexHCJP/markup_analyzer)
![Stars](https://img.shields.io/github/stars/AlexHCJP/markup_analyzer)

## Description

`Markup Analyzer` is a customizable lint rule for the [`custom_lint`](https://pub.dev/packages/custom_lint) package in Dart/Flutter. It allows you to prohibit specific types of string expressions in the parameters of Flutter widgets.

This rule enables you to control the usage of string expressions such as simple string literals, interpolations, binary expressions, and others based on your configuration.


- [MarkupAnalyzer Lint Rule](#markupanalyzer-lint-rule)
  - [Description](#description)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Usage](#usage)
  - [Examples](#examples)
    - [1. Simple String Literals (`simple`)](#1-simple-string-literals-simple)
    - [2. Prefixed Identifiers (`prefixed_identifier`)](#2-prefixed-identifiers-prefixed_identifier)
    - [3. String Interpolation (`interpolation`)](#3-string-interpolation-interpolation)
    - [4. Binary Expressions (`binary`)](#4-binary-expressions-binary)
    - [5. Adjacent Strings (`adjacent`)](#5-adjacent-strings-adjacent)
    - [6. Method Invocations (`method`)](#6-method-invocations-method)
    - [7. Simple Identifiers (`simple_identifier`)](#7-simple-identifiers-simple_identifier)
    - [8. Function Invocations (`function`)](#8-function-invocations-function)

## Installation

1. **Add the package to your project's dependencies:**

   Add the following to your project's `pubspec.yaml` under `dev_dependencies`:

   ```yaml
   dev_dependencies:
     custom_lint: 
     markup_analyzer: ^latest_version
   ```

2. **Get the dependencies:**

   ```bash
   flutter pub get
   ```

3. **Activate the plugin in `analysis_options.yaml`:**

   Create or update the `analysis_options.yaml` file at the root of your project:

   ```yaml
   analyzer:
     plugins:
       - custom_lint

   custom_lint:
     rules:
       - markup_analyzer
   ```

## Configuration

You can configure the `MarkupAnalyzer` rule via `analysis_options.yaml` by specifying which types of string expressions should be prohibited, the severity level of the error, and additional options for customization.

### Basic Configuration

Example of a basic configuration:

```yaml
custom_lint:
  rules:
    - markup_analyzer:
      simple: error
      interpolation: warning
      binary: warning
      adjacent: warning
      prefixed_identifier: none
      method: none
      simple_identifier: none
      function: none
```

### Advanced Configuration

Example of an advanced configuration with all available options:

```yaml
custom_lint:
  rules:
    - markup_analyzer:
        # String expression types and their severities
        simple: error
        interpolation: warning
        binary: warning
        adjacent: warning
        prefixed_identifier: none
        method: none
        simple_identifier: none
        function: none
        
        # Exclude specific file patterns from analysis
        exclude_patterns:
          - ".*\\.generated\\.dart$"
          - ".*\\.g\\.dart$"
          - "test/.*\\.dart$"
        
        # Only analyze specific widget types (if not specified, all widgets are analyzed)
        include_widget_types:
          - "Text"
          - "Button"
          - "AppBar"
        
        # Exclude specific widget types from analysis
        exclude_widget_types:
          - "DebugWidget"
          - "TestWidget"
        
        # Enable or disable helpful suggestions in error messages (default: true)
        enable_suggestions: true
```

### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `simple` | `error/warning/info/none` | `none` | Simple string literals (`'text'`) |
| `interpolation` | `error/warning/info/none` | `none` | String interpolation (`'Hello $name'`) |
| `binary` | `error/warning/info/none` | `none` | Binary expressions (`'a' + 'b'`) |
| `adjacent` | `error/warning/info/none` | `none` | Adjacent strings (`'a' 'b'`) |
| `prefixed_identifier` | `error/warning/info/none` | `none` | Prefixed identifiers (`widget.title`) |
| `method` | `error/warning/info/none` | `none` | Method invocations (`getText()`) |
| `simple_identifier` | `error/warning/info/none` | `none` | Simple identifiers (`title`) |
| `function` | `error/warning/info/none` | `none` | Function expressions (`() => 'text'`) |
| `exclude_patterns` | `List<String>` | `null` | Regex patterns for files to exclude |
| `include_widget_types` | `List<String>` | `null` | Widget types to include (whitelist) |
| `exclude_widget_types` | `List<String>` | `null` | Widget types to exclude (blacklist) |
| `enable_suggestions` | `bool` | `true` | Include helpful suggestions in error messages |

## Usage

After setting up the plugin and configuring the rules, run the analyzer on your project:

```bash
dart run custom_lint
```

All rule violations will be displayed in the console and highlighted in your IDE if it supports `custom_lint`.


## Examples

### 1. Simple String Literals (`simple`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      simple: error
  ```

  ```dart
  // BAD
  Text('Hello, world!'); // Simple string literal is prohibited.

  // OR GOOD
  Text(AppLocalizations.of(context).greeting)
  ```

### 2. Prefixed Identifiers (`prefixed_identifier`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      prefixed_identifier: error
  ```

  ```dart
  // ERROR
  Text(widget.title); // Prefixed identifier is prohibited.
  ```

### 3. String Interpolation (`interpolation`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      interpolation: error
  ```

  ```dart
  // BAD
  Text('Hello, $name!'); // String interpolation is prohibited.

  // GOOD
  Text(AppLocalizations.of(context).helloWithName(name)); // Use string concatenation instead.
  ```

### 4. Binary Expressions (`binary`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      binary: error
  ```


  ```dart
  // ERROR
  Text('Hello, ' + 'world!'); // Binary expression with '+' is prohibited.
  ```

### 5. Adjacent Strings (`adjacent`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      adjacent: error
  ```

  ```dart
  // ERROR
  Text(
  'Hello, '
  'world!'
  ); // Adjacent strings are prohibited.
  ```

### 6. Method Invocations (`method`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      method: error
  ```

  ```dart
  // BAD
  Text('hello'.tr()); // Method invocation is prohibited.

  //GOOD
  Text(AppLocalizations.of(context).hello)
  ```

### 7. Simple Identifiers (`simple_identifier`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      simple_identifier: error
  ```

  ```dart
  // ERROR
  Text(title); // Simple identifier is prohibited.
  ```

### 8. Function Invocations (`function`)

**Configuration:**

  ```yaml
custom_lint:
  rules:
    markup_analyzer:
      function: error
  ```

  ```dart
  // ERROR
  Text(() { return 'Hello' } ()); // Function invocation is prohibited.

  ```

### 9. Advanced Configuration Examples

**Exclude generated files:**

```yaml
custom_lint:
  rules:
    - markup_analyzer:
        simple: error
        exclude_patterns:
          - ".*\\.generated\\.dart$"
          - ".*\\.g\\.dart$"
```

**Only check specific widgets:**

```yaml
custom_lint:
  rules:
    - markup_analyzer:
        simple: error
        include_widget_types:
          - "Text"
          - "AppBar"
```

**Exclude debug widgets:**

```yaml
custom_lint:
  rules:
    - markup_analyzer:
        simple: error
        exclude_widget_types:
          - "DebugWidget"
          - "TestWidget"
```

**Disable suggestions for cleaner output:**

```yaml
custom_lint:
  rules:
    - markup_analyzer:
        simple: error
        enable_suggestions: false
```

## Development

### Running Tests

```bash
# Run all tests
make test

# Run tests with coverage
make test-coverage

# View coverage report
make coverage
```

### Code Quality

```bash
# Format code
make format

# Analyze code
make analyze

# Run all quality checks
make precommit
```

### Building Documentation

```bash
# Generate documentation
make dartdoc
```



<img align="left" src = "https://profile-counter.glitch.me/markup_analyzer/count.svg" alt ="Loading">