import 'package:analyzer/error/error.dart';
import 'package:collection/collection.dart';

/// Extension on [DiagnosticSeverity] to provide utility methods for parsing.
extension ErrorSeverityExt on DiagnosticSeverity {
  /// Parses a [String] into an [DiagnosticSeverity] instance.
  ///
  /// - Returns `null` if the value is `'none'` (case-insensitive), indicating
  ///   that the severity should be treated as disabled.
  /// - Returns the matching [DiagnosticSeverity] if a match is found, ignoring case.
  /// - Returns `null` if the string does not match any known severity.
  static DiagnosticSeverity? fromString(String? value) {
    if (value?.toUpperCase() == DiagnosticSeverity.NONE.name.toUpperCase()) {
      return null;
    }

    return DiagnosticSeverity.values.firstWhereOrNull(
      (severity) => severity.name.toUpperCase() == value?.toUpperCase(),
    );
  }
}
