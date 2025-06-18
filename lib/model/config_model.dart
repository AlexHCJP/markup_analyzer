import 'dart:io';

import 'package:analyzer/error/error.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:markup_analyzer/extensions/severity_extension.dart';

class ConfigModel {
  ConfigModel({
    this.simple,
    this.prefixedIdentifier,
    this.interpolation,
    this.binary,
    this.adjacent,
    this.method,
    this.simpleIdentifier,
    this.property,
    this.function,
  });

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
        property: ErrorSeverityExt.fromString(map['property'] as String?),
        function: ErrorSeverityExt.fromString(map['function'] as String?),
      );


  factory ConfigModel.fromRules(Map<String, LintOptions> rules) {
    if (rules.isEmpty) return ConfigModel();

    try {
      return ConfigModel.fromMap(
        rules.entries.first.value.json,
      );
    } on Exception catch (error, stackTrace) {
      stdout
        ..write(error)
        ..write(stackTrace);
      return ConfigModel();
    }
  }

  final ErrorSeverity? simple;
  final ErrorSeverity? prefixedIdentifier;
  final ErrorSeverity? interpolation;
  final ErrorSeverity? binary;
  final ErrorSeverity? adjacent;
  final ErrorSeverity? method;
  final ErrorSeverity? simpleIdentifier;
  final ErrorSeverity? property;
  final ErrorSeverity? function;
}
