import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:markup_analyzer/src/utils/widget_checker.dart';

/// Flags string interpolations passed to widget constructors.
class StringInterpolationRule extends AnalysisRule {
  /// Creates an instance of [StringInterpolationRule].
  StringInterpolationRule()
    : super(
        name: 'string_interpolation',
        description: 'Disallows string interpolations in widget parameters.',
        state: const RuleState.stable(),
      );

  /// The lint code reported by this rule.
  static const LintCode code = LintCode(
    'string_interpolation',
    'String interpolation is not allowed in widget parameters.',
    correctionMessage: 'Use a localized string with parameters instead.',
  );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addArgumentList(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> with WidgetCheckerMixin {
  _Visitor(this.rule);
  final StringInterpolationRule rule;

  @override
  void visitArgumentList(ArgumentList node) {
    if (!isWidgetConstructorCall(node.parent)) return;
    for (final argument in node.arguments) {
      final expr = argument.argumentExpression;
      if (expr is StringInterpolation) {
        rule.reportAtNode(expr);
      }
    }
  }
}
