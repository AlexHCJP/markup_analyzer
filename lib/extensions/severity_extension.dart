import 'package:analyzer/error/error.dart';
import 'package:collection/collection.dart';

extension ErrorSeverityExt on ErrorSeverity {
  static ErrorSeverity? fromString(String? value) {
    if (value?.toUpperCase() == ErrorSeverity.NONE.name.toUpperCase()) {
      return null;
    }
    return ErrorSeverity.values.firstWhereOrNull(
      (severity) => severity.name.toUpperCase() == value?.toUpperCase(),
    );
  }
}
