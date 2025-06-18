import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:markup_analyzer/model/config_model.dart';
import 'package:markup_analyzer/rules/string_rule.dart';

PluginBase createPlugin() => _MarkupLinter();

class _MarkupLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    final config = ConfigModel.fromRules(configs.rules);
    return [
      StringLintRule(config),
    ];
  }
}
