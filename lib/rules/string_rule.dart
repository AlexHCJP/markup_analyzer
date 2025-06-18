import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:markup_analyzer/model/config_model.dart';

class StringLintRule extends DartLintRule {
  const StringLintRule(this.config)
      : super(
          code: const LintCode(name: '', problemMessage: ''),
        );

  final ConfigModel config;

  static const TypeChecker _widgetChecker = TypeChecker.fromName(
    'Widget',
  );

  static const TypeChecker _stringChecker = TypeChecker.fromName(
    'String',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addArgumentList((argumentList) {
      if (argumentList.parent case InstanceCreationExpression object) {
        final superTypes =
            object.constructorName.element?.returnType.allSupertypes;

        superTypes?.forEach((type) {
          if (!_widgetChecker.isExactlyType(type)) return;
          _checkParameters(reporter, argumentList);
        });
      }
    });
  }

  void _checkParameters(ErrorReporter reporter, ArgumentList argumentList) {
    for (final arg in argumentList.arguments) {
      final argStaticType = arg.staticType;
      if (argStaticType == null) return;
      if (!_stringChecker.isExactlyType(argStaticType)) return;
      if (_checkValue(arg) case LintCode code) reporter.atNode(arg, code);
    }
  }

  LintCode? _checkValue(Expression arg) => switch (arg) {
        SimpleStringLiteral() when config.simple != null => LintCode(
            name: 'simple_string',
            problemMessage: 'Simple string literal is not allowed.',
            errorSeverity: config.simple!,
          ),
        PrefixedIdentifier() when config.prefixedIdentifier != null => LintCode(
            name: 'prefixed_identifier',
            problemMessage: 'Prefixed identifier is not allowed.',
            errorSeverity: config.prefixedIdentifier!,
          ),
        StringInterpolation() when config.interpolation != null => LintCode(
            name: 'string_interpolation',
            problemMessage: 'String interpolation is not allowed.',
            errorSeverity: config.interpolation!,
          ),
        BinaryExpression() when config.binary != null => LintCode(
            name: 'binary_expression',
            problemMessage: 'Binary expression is not allowed.',
            errorSeverity: config.binary!,
          ),
        AdjacentStrings() when config.adjacent != null => LintCode(
            name: 'adjacent_strings',
            problemMessage: 'Adjacent strings are not allowed.',
            errorSeverity: config.adjacent!,
          ),
        MethodInvocation() when config.method != null => LintCode(
            name: 'method_invocation',
            problemMessage: 'Method invocation is not allowed.',
            errorSeverity: config.method!,
          ),
        SimpleIdentifier() when config.simpleIdentifier != null => LintCode(
            name: 'simple_identifier',
            problemMessage: 'Simple identifier is not allowed.',
            errorSeverity: config.simpleIdentifier!,
          ),
        FunctionExpressionInvocation() when config.function != null => LintCode(
            name: 'function_invocation',
            problemMessage: 'Function expression invocation is not allowed.',
            errorSeverity: config.function!,
          ),
        PropertyAccess() when config.property != null => LintCode(
            name: 'property_access',
            problemMessage: 'Property access is not allowed.',
            errorSeverity: config.property!,
          ),
        NamedExpression(:Expression expression) => _checkValue(expression),
        _ => null,
      };
}
