import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:markup_analyzer/src/utils/widget_checker.dart';

/// Flags simple string literals passed to widget constructors.
class SimpleStringRule extends AnalysisRule {
  /// Creates an instance of [SimpleStringRule].
  SimpleStringRule()
    : super(
        name: 'simple_string',
        description: 'Disallows simple string literals in widget parameters.',
        state: const RuleState.stable(),
      );

  /// The lint code reported by this rule.
  static const LintCode code = LintCode(
    'simple_string',
    'Simple string literal is not allowed in widget parameters.',
    correctionMessage: 'Use a localized string instead.',
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
  final SimpleStringRule rule;

  @override
  void visitArgumentList(ArgumentList node) {
    if (!isWidgetConstructorCall(node.parent)) return;
    for (final argument in node.arguments) {
      final expr = argument.argumentExpression;
      if (expr is SimpleStringLiteral) {
        rule.reportAtNode(expr);
      }
    }
  }
}
