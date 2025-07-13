import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:markup_analyzer/model/config_model.dart';
import 'package:markup_analyzer/rules/string_rule.dart';

/// Markup analysis plugin
///
/// This file contains the core logic for markup analysis plugin.
/// The plugin implements custom lint rules for string validation.

/// Factory method to create a plugin instance
///
/// Returns a [_MarkupLinter] instance that implements basic plugin functionality
PluginBase createPlugin() => _MarkupLinter();

/// Main plugin class for markup analysis
///
/// Implements [PluginBase] and provides configurable lint rules
class _MarkupLinter extends PluginBase {
  /// Returns a list of active lint rules
  ///
  /// Parameters:
  /// - [configs] - linter configuration with rules
  ///
  /// Returns a list of [LintRule] containing string validation rules
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    final config = ConfigModel.fromRules(configs.rules);
    return [
      StringLintRule(config),
    ];
  }
}
