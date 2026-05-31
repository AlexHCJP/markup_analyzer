import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:markup_analyzer/src/rules/adjacent_strings_rule.dart';
import 'package:markup_analyzer/src/rules/binary_expression_rule.dart';
import 'package:markup_analyzer/src/rules/function_invocation_rule.dart';
import 'package:markup_analyzer/src/rules/method_invocation_rule.dart';
import 'package:markup_analyzer/src/rules/prefixed_identifier_rule.dart';
import 'package:markup_analyzer/src/rules/simple_identifier_rule.dart';
import 'package:markup_analyzer/src/rules/simple_string_rule.dart';
import 'package:markup_analyzer/src/rules/string_interpolation_rule.dart';

/// The markup_analyzer plugin instance loaded by the analysis server.
final plugin = MarkupAnalyzerPlugin();

/// Plugin that enforces localization in Flutter widget parameters.
class MarkupAnalyzerPlugin extends Plugin {
  @override
  String get name => 'markup_analyzer';

  @override
  void register(PluginRegistry registry) {
    registry
      ..registerWarningRule(SimpleStringRule())
      ..registerWarningRule(StringInterpolationRule())
      ..registerWarningRule(AdjacentStringsRule())
      ..registerWarningRule(BinaryExpressionRule())
      ..registerWarningRule(PrefixedIdentifierRule())
      ..registerWarningRule(MethodInvocationRule())
      ..registerWarningRule(SimpleIdentifierRule())
      ..registerWarningRule(FunctionInvocationRule());
  }
}
