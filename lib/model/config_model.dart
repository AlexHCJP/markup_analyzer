import 'dart:io';
import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:markup_analyzer/extensions/severity_extension.dart';

/// Configuration model used to define which types of string expressions
/// are allowed or disallowed in lint rules, along with their respective severities.
class ConfigModel {
  /// Creates a [ConfigModel] with individual severity settings for each expression type.
  ConfigModel({
    this.simple,
    this.prefixedIdentifier,
    this.interpolation,
    this.binary,
    this.adjacent,
    this.method,
    this.simpleIdentifier,
    this.function,
  });

  /// Factory constructor to create a [ConfigModel] from a raw [Map].
  ///
  /// Each key in the map represents a string expression type, and the value is
  /// a string that will be parsed into an [ErrorSeverity] using the
  /// [ErrorSeverityExt.fromString] extension.
  factory ConfigModel.fromMap(Map<String, dynamic> map) => ConfigModel(
        simple: ErrorSeverityExt.fromString(map['simple'] as String?),
        prefixedIdentifier:
            ErrorSeverityExt.fromString(map['prefixed_identifier'] as String?),
        interpolation:
            ErrorSeverityExt.fromString(map['interpolation'] as String?),
        binary: ErrorSeverityExt.fromString(map['binary'] as String?),
        adjacent: ErrorSeverityExt.fromString(map['adjacent'] as String?),
        method: ErrorSeverityExt.fromString(map['method'] as String?),
        simpleIdentifier:
            ErrorSeverityExt.fromString(map['simple_identifier'] as String?),
        function: ErrorSeverityExt.fromString(map['function'] as String?),
      );

  /// Factory constructor to create a [ConfigModel] from a [LintOptions] map.
  ///
  /// If the map is empty, returns a default configuration.
  /// Otherwise, attempts to read the first rule's configuration and parse it.
  /// Errors are printed to stdout if parsing fails.
  factory ConfigModel.fromRules(Map<String, LintOptions> rules) {
    if (rules.isEmpty) return ConfigModel();

    try {
      return ConfigModel.fromMap(
        rules.entries.first.value.json,
      );
    } on Exception catch (error, stackTrace) {
      // Log parsing errors to stdout
      stdout
        ..write(error)
        ..write(stackTrace);
      return ConfigModel();
    }
  }

  /// Severity for simple string literals (e.g., `'text'`)
  final ErrorSeverity? simple;

  /// Severity for prefixed identifiers (e.g., `ClassName.string`)
  final ErrorSeverity? prefixedIdentifier;

  /// Severity for string interpolations (e.g., `'Hello $name'`)
  final ErrorSeverity? interpolation;

  /// Severity for binary expressions involving strings (e.g., `'a' + 'b'`)
  final ErrorSeverity? binary;

  /// Severity for adjacent string literals (e.g., `'a' 'b'`)
  final ErrorSeverity? adjacent;

  /// Severity for method invocations returning strings (e.g., `getText()`)
  final ErrorSeverity? method;

  /// Severity for simple identifiers referring to strings (e.g., `label`)
  final ErrorSeverity? simpleIdentifier;

  /// Severity for function expression invocations returning strings (e.g., `() => 'text'`)
  final ErrorSeverity? function;
}
