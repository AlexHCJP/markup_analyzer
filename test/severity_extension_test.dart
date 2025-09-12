import 'package:analyzer/error/error.dart';
import 'package:markup_analyzer/extensions/severity_extension.dart';
import 'package:test/test.dart';

void main() {
  group('ErrorSeverityExt', () {
    group('fromString', () {
      test('should parse standard severity values correctly', () {
        expect(ErrorSeverityExt.fromString('error'), equals(DiagnosticSeverity.ERROR));
        expect(ErrorSeverityExt.fromString('warning'), equals(DiagnosticSeverity.WARNING));
        expect(ErrorSeverityExt.fromString('info'), equals(DiagnosticSeverity.INFO));
      });

      test('should parse uppercase severity values correctly', () {
        expect(ErrorSeverityExt.fromString('ERROR'), equals(DiagnosticSeverity.ERROR));
        expect(ErrorSeverityExt.fromString('WARNING'), equals(DiagnosticSeverity.WARNING));
        expect(ErrorSeverityExt.fromString('INFO'), equals(DiagnosticSeverity.INFO));
      });

      test('should parse mixed case severity values correctly', () {
        expect(ErrorSeverityExt.fromString('Error'), equals(DiagnosticSeverity.ERROR));
        expect(ErrorSeverityExt.fromString('Warning'), equals(DiagnosticSeverity.WARNING));
        expect(ErrorSeverityExt.fromString('Info'), equals(DiagnosticSeverity.INFO));
        expect(ErrorSeverityExt.fromString('eRrOr'), equals(DiagnosticSeverity.ERROR));
        expect(ErrorSeverityExt.fromString('wArNiNg'), equals(DiagnosticSeverity.WARNING));
        expect(ErrorSeverityExt.fromString('iNfO'), equals(DiagnosticSeverity.INFO));
      });

      test('should return null for "none" values', () {
        expect(ErrorSeverityExt.fromString('none'), isNull);
        expect(ErrorSeverityExt.fromString('NONE'), isNull);
        expect(ErrorSeverityExt.fromString('None'), isNull);
        expect(ErrorSeverityExt.fromString('nOnE'), isNull);
      });

      test('should return null for invalid values', () {
        expect(ErrorSeverityExt.fromString('invalid'), isNull);
        expect(ErrorSeverityExt.fromString('critical'), isNull);
        expect(ErrorSeverityExt.fromString('debug'), isNull);
        expect(ErrorSeverityExt.fromString('trace'), isNull);
        expect(ErrorSeverityExt.fromString(''), isNull);
        expect(ErrorSeverityExt.fromString('   '), isNull);
        expect(ErrorSeverityExt.fromString('error '), isNull); // Trailing space
        expect(ErrorSeverityExt.fromString(' error'), isNull); // Leading space
      });

      test('should return null for null input', () {
        expect(ErrorSeverityExt.fromString(null), isNull);
      });

      test('should handle all DiagnosticSeverity enum values', () {
        // Test that all actual enum values can be parsed
        for (final severity in DiagnosticSeverity.values) {
          final parsed = ErrorSeverityExt.fromString(severity.name);
          expect(parsed, equals(severity), reason: 'Failed to parse ${severity.name}');
          
          // Test case insensitive parsing
          final parsedLower = ErrorSeverityExt.fromString(severity.name.toLowerCase());
          expect(parsedLower, equals(severity), reason: 'Failed to parse ${severity.name.toLowerCase()}');
          
          final parsedUpper = ErrorSeverityExt.fromString(severity.name.toUpperCase());
          expect(parsedUpper, equals(severity), reason: 'Failed to parse ${severity.name.toUpperCase()}');
        }
      });

      test('should handle special edge cases', () {
        // Empty strings and whitespace
        expect(ErrorSeverityExt.fromString(''), isNull);
        expect(ErrorSeverityExt.fromString('   '), isNull);
        expect(ErrorSeverityExt.fromString('\t'), isNull);
        expect(ErrorSeverityExt.fromString('\n'), isNull);
        
        // Numbers and special characters
        expect(ErrorSeverityExt.fromString('1'), isNull);
        expect(ErrorSeverityExt.fromString('0'), isNull);
        expect(ErrorSeverityExt.fromString('!@#'), isNull);
        expect(ErrorSeverityExt.fromString('error!'), isNull);
      });

      test('should be consistent with NONE handling', () {
        // Ensure NONE is treated specially and returns null
        expect(ErrorSeverityExt.fromString(DiagnosticSeverity.NONE.name), isNull);
        expect(ErrorSeverityExt.fromString(DiagnosticSeverity.NONE.name.toLowerCase()), isNull);
        expect(ErrorSeverityExt.fromString(DiagnosticSeverity.NONE.name.toUpperCase()), isNull);
      });
    });
  });
}