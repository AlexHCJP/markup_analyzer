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
    this.excludePatterns,
    this.includeWidgetTypes,
    this.excludeWidgetTypes,
    this.enableSuggestions = true,
  });

  /// Factory constructor to create a [ConfigModel] from a raw [Map].
  ///
  /// Each key in the map represents a string expression type, and the value is
  /// a string that will be parsed into an [DiagnosticSeverity] using the
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
        excludePatterns: _parseStringList(map['exclude_patterns']),
        includeWidgetTypes: _parseStringList(map['include_widget_types']),
        excludeWidgetTypes: _parseStringList(map['exclude_widget_types']),
        enableSuggestions: map['enable_suggestions'] as bool? ?? true,
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

  /// Helper method to parse string lists from configuration
  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String) {
      return [value];
    }
    return null;
  }

  /// Severity for simple string literals (e.g., `'text'`)
  final DiagnosticSeverity? simple;

  /// Severity for prefixed identifiers (e.g., `ClassName.string`)
  final DiagnosticSeverity? prefixedIdentifier;

  /// Severity for string interpolations (e.g., `'Hello $name'`)
  final DiagnosticSeverity? interpolation;

  /// Severity for binary expressions involving strings (e.g., `'a' + 'b'`)
  final DiagnosticSeverity? binary;

  /// Severity for adjacent string literals (e.g., `'a' 'b'`)
  final DiagnosticSeverity? adjacent;

  /// Severity for method invocations returning strings (e.g., `getText()`)
  final DiagnosticSeverity? method;

  /// Severity for simple identifiers referring to strings (e.g., `label`)
  final DiagnosticSeverity? simpleIdentifier;

  /// Severity for function expression invocations returning strings (e.g., `() => 'text'`)
  final DiagnosticSeverity? function;

  /// List of regex patterns to exclude from analysis (e.g., test files, generated files)
  final List<String>? excludePatterns;

  /// List of widget types to include in analysis (if specified, only these widgets will be checked)
  final List<String>? includeWidgetTypes;

  /// List of widget types to exclude from analysis
  final List<String>? excludeWidgetTypes;

  /// Whether to include helpful suggestions in error messages
  final bool enableSuggestions;

  /// Checks if a widget type should be analyzed based on include/exclude lists
  bool shouldAnalyzeWidget(String widgetTypeName) {
    // If exclude list is specified and widget is in it, don't analyze
    if (excludeWidgetTypes?.contains(widgetTypeName) == true) {
      return false;
    }

    // If include list is specified, only analyze widgets in the list
    if (includeWidgetTypes != null) {
      return includeWidgetTypes!.contains(widgetTypeName);
    }

    // Default: analyze all widgets not explicitly excluded
    return true;
  }

  /// Checks if a file path should be excluded based on exclude patterns
  bool shouldExcludeFile(String filePath) {
    if (excludePatterns == null) return false;

    for (final pattern in excludePatterns!) {
      if (RegExp(pattern).hasMatch(filePath)) {
        return true;
      }
    }
    return false;
  }
}
