import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:markup_analyzer/src/rules/string_rule.dart';

/// The markup_analyzer plugin instance loaded by the analysis server.
final plugin = MarkupAnalyzerPlugin();

class MarkupAnalyzerPlugin extends Plugin {
  @override
  String get name => 'markup_analyzer';

  @override
  void register(PluginRegistry registry) {
    registry.registerWarningRule(StringLintRule());
  }
}
