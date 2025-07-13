import 'package:analyzer/error/error.dart';
import 'package:collection/collection.dart';

/// Extension on [ErrorSeverity] to provide utility methods for parsing.
extension ErrorSeverityExt on ErrorSeverity {
  /// Parses a [String] into an [ErrorSeverity] instance.
  ///
  /// - Returns `null` if the value is `'none'` (case-insensitive), indicating
  ///   that the severity should be treated as disabled.
  /// - Returns the matching [ErrorSeverity] if a match is found, ignoring case.
  /// - Returns `null` if the string does not match any known severity.
  static ErrorSeverity? fromString(String? value) {
    if (value?.toUpperCase() == ErrorSeverity.NONE.name.toUpperCase()) {
      return null;
    }

    return ErrorSeverity.values.firstWhereOrNull(
      (severity) => severity.name.toUpperCase() == value?.toUpperCase(),
    );
  }
}
