import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:markup_analyzer/src/utils/widget_checker.dart';

/// Flags raw string literals reached through a binary expression in a widget
/// parameter.
///
/// Every other rule looks at the argument itself, so a literal one operator
/// deep — `'Hello, ' + name`, `title ?? 'Untitled'` — passes all of them. This
/// rule is how they reach it: it walks the operands and reports the literals
/// found there.
///
/// It is deliberately not [BinaryExpressionRule]. That one flags the whole
/// expression, and an expression is not evidence by itself: `label ??
/// l10n.fallback` is two localized values with an operator between them. Enable
/// this rule and disable that one to require localization without calling `??`
/// a mistake; enable both to forbid the operator outright.
class BinaryStringLiteralRule extends AnalysisRule {
  /// Creates an instance of [BinaryStringLiteralRule].
  BinaryStringLiteralRule()
    : super(
        name: 'binary_string_literal',
        description:
            'Disallows raw string literals inside binary expressions in '
            'widget parameters.',
        state: const RuleState.stable(),
      );

  /// The lint code reported by this rule.
  static const LintCode code = LintCode(
    'binary_string_literal',
    'Raw string inside a binary expression is not allowed in widget '
        'parameters.',
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
  final BinaryStringLiteralRule rule;

  @override
  void visitArgumentList(ArgumentList node) {
    if (!isWidgetConstructorCall(node.parent)) return;
    for (final argument in node.arguments) {
      final expr = argument.argumentExpression;
      if (expr is! BinaryExpression) continue;
      if (expr.staticType?.isDartCoreString != true) continue;
      _rawStrings(expr).forEach(rule.reportAtNode);
    }
  }

  /// The literals this expression can put on screen.
  ///
  /// Operators chain, so `a ?? b ?? 'text'` holds the literal two levels down
  /// and the walk recurses. Everything else an operand may be — an identifier,
  /// a call, a localized getter — belongs to the rule that names it.
  Iterable<StringLiteral> _rawStrings(BinaryExpression node) sync* {
    for (final operand in [node.leftOperand, node.rightOperand]) {
      switch (operand.unParenthesized) {
        case final BinaryExpression nested:
          yield* _rawStrings(nested);
        case final StringLiteral literal:
          // `?? ''` stands for "nothing yet", not for a line somebody forgot
          // to translate: there is no text in it to translate.
          if (literal.stringValue?.isEmpty ?? false) continue;
          yield literal;
      }
    }
  }
}
