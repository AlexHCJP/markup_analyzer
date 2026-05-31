import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_state.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';

/// Lint rule that disallows raw string expressions as widget constructor
/// arguments, encouraging the use of localized strings instead.
class StringLintRule extends MultiAnalysisRule {
  /// Creates an instance of [StringLintRule].
  StringLintRule()
    : super(
        name: 'markup_analyzer',
        description:
            'Disallows raw string expressions as widget constructor arguments.',
        state: const RuleState.stable(),
      );

  /// Reported when a simple string literal is passed to a widget.
  static const LintCode simpleString = LintCode(
    'simple_string',
    'Simple string literal is not allowed in widget parameters.',
    correctionMessage: 'Use a localized string instead.',
    severity: DiagnosticSeverity.NONE,
  );

  /// Reported when a prefixed identifier (e.g. `widget.title`) is passed.
  static const LintCode prefixedIdentifier = LintCode(
    'prefixed_identifier',
    'Prefixed identifier is not allowed in widget parameters.',
    correctionMessage: 'Use a localized string instead.',
    severity: DiagnosticSeverity.NONE,
  );

  /// Reported when a string interpolation is passed to a widget.
  static const LintCode stringInterpolation = LintCode(
    'string_interpolation',
    'String interpolation is not allowed in widget parameters.',
    correctionMessage: 'Use a localized string with parameters instead.',
    severity: DiagnosticSeverity.NONE,
  );

  /// Reported when a binary string expression (e.g. `'a' + 'b'`) is passed.
  static const LintCode binaryExpression = LintCode(
    'binary_expression',
    'Binary string expression is not allowed in widget parameters.',
    correctionMessage: 'Use a localized string instead.',
    severity: DiagnosticSeverity.NONE,
  );

  /// Reported when adjacent string literals are passed to a widget.
  static const LintCode adjacentStrings = LintCode(
    'adjacent_strings',
    'Adjacent string literals are not allowed in widget parameters.',
    correctionMessage: 'Use a localized string instead.',
    severity: DiagnosticSeverity.NONE,
  );

  /// Reported when a string method invocation (e.g. `'x'.tr()`) is passed.
  static const LintCode methodInvocation = LintCode(
    'method_invocation',
    'String method invocation is not allowed in widget parameters.',
    correctionMessage: 'Use a localized string instead.',
    severity: DiagnosticSeverity.NONE,
  );

  /// Reported when a bare string identifier is passed to a widget.
  static const LintCode simpleIdentifier = LintCode(
    'simple_identifier',
    'Simple string identifier is not allowed in widget parameters.',
    correctionMessage: 'Use a localized string instead.',
    severity: DiagnosticSeverity.NONE,
  );

  /// Reported when a function expression returning a string is passed.
  static const LintCode functionInvocation = LintCode(
    'function_invocation',
    'Function expression returning a string is not allowed in widget parameters.',
    correctionMessage: 'Use a localized string instead.',
    severity: DiagnosticSeverity.NONE,
  );

  @override
  List<LintCode> get diagnosticCodes => [
    simpleString,
    prefixedIdentifier,
    stringInterpolation,
    binaryExpression,
    adjacentStrings,
    methodInvocation,
    simpleIdentifier,
    functionInvocation,
  ];

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addArgumentList(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final StringLintRule rule;

  final RuleContext context;

  bool _isWidgetType(DartType? type) {
    if (type is! InterfaceType) return false;
    return [type, ...type.allSupertypes].any((t) => t.element.name == 'Widget');
  }

  bool _isWidgetConstructorCall(AstNode? node) {
    if (node is! InstanceCreationExpression) return false;
    return _isWidgetType(node.staticType);
  }

  @override
  void visitArgumentList(ArgumentList node) {
    if (!_isWidgetConstructorCall(node.parent)) return;

    for (final argument in node.arguments) {
      final expr = argument.argumentExpression;
      if (expr is SimpleStringLiteral) {
        rule.reportAtNode(expr, diagnosticCode: StringLintRule.simpleString);
      }
      if (expr is StringInterpolation) {
        rule.reportAtNode(
          expr,
          diagnosticCode: StringLintRule.stringInterpolation,
        );
      }
      if (expr is AdjacentStrings) {
        rule.reportAtNode(expr, diagnosticCode: StringLintRule.adjacentStrings);
      }
      if (expr is PrefixedIdentifier &&
          expr.staticType?.isDartCoreString == true) {
        rule.reportAtNode(
          expr,
          diagnosticCode: StringLintRule.prefixedIdentifier,
        );
      }
      if (expr is BinaryExpression &&
          expr.staticType?.isDartCoreString == true) {
        rule.reportAtNode(
          expr,
          diagnosticCode: StringLintRule.binaryExpression,
        );
      } else if (expr case MethodInvocation()
          when expr.staticType?.isDartCoreString == true) {
        rule.reportAtNode(
          expr,
          diagnosticCode: StringLintRule.methodInvocation,
        );
      } else if (expr is SimpleIdentifier &&
          expr.staticType?.isDartCoreString == true) {
        rule.reportAtNode(
          expr,
          diagnosticCode: StringLintRule.simpleIdentifier,
        );
      } else if (expr is FunctionExpression &&
          expr.staticType?.isDartCoreString == true) {
        rule.reportAtNode(
          expr,
          diagnosticCode: StringLintRule.functionInvocation,
        );
      }
    }
  }
}
