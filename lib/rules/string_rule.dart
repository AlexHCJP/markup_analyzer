import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:markup_analyzer/model/config_model.dart';

/// A custom lint rule that validates string expressions used in widget constructors
/// based on the provided configuration.
class StringLintRule extends DartLintRule {
  /// Creates an instance of [StringLintRule] with the given [config].
  const StringLintRule(this.config)
      : super(
          code: const LintCode(name: '', problemMessage: ''),
        );

  /// The linting configuration specifying which string expressions are allowed.
  final ConfigModel config;

  /// Type checker for Flutter [Widget] types.
  static const TypeChecker _widgetChecker = TypeChecker.fromName('Widget');

  /// Type checker for Dart [String] types.
  static const TypeChecker _stringChecker = TypeChecker.fromName('String');

  /// Registers this rule to listen to [ArgumentList] nodes and checks arguments
  /// passed to widget constructors.
  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addArgumentList((argumentList) {
      // Check if file should be excluded
      final filePath = argumentList.root.source?.fullName ?? '';
      if (config.shouldExcludeFile(filePath)) return;

      if (argumentList.parent case InstanceCreationExpression object) {
        final constructorElement = object.constructorName.element;
        final returnType = constructorElement?.returnType;
        
        if (returnType == null) return;

        final superTypes = returnType.allSupertypes;
        final widgetTypeName = returnType.element?.name ?? '';

        // Check if this widget type should be analyzed
        if (!config.shouldAnalyzeWidget(widgetTypeName)) return;

        superTypes?.forEach((type) {
          if (!_widgetChecker.isExactlyType(type)) return;
          _checkParameters(reporter, argumentList);
        });
      }
    });
  }

  /// Checks all arguments in the list. If an argument is a String and violates
  /// the configuration, it reports a lint at that node.
  void _checkParameters(DiagnosticReporter reporter, ArgumentList argumentList) {
    for (final arg in argumentList.arguments) {
      final argStaticType = arg.staticType;
      if (argStaticType == null) return;
      if (!_stringChecker.isExactlyType(argStaticType)) return;
      if (_checkValue(arg) case LintCode code) reporter.atNode(arg, code);
    }
  }

  /// Determines whether a given [Expression] violates any configured string
  /// usage rules and returns the corresponding [LintCode] if so.
  LintCode? _checkValue(Expression arg) => switch (arg) {
        SimpleStringLiteral() when config.simple != null => LintCode(
            name: 'simple_string',
            problemMessage: config.enableSuggestions
                ? 'Avoid using hardcoded string literals in widgets. '
                    'Consider using localization methods like AppLocalizations.of(context).yourKey or a string constant.'
                : 'Simple string literal is not allowed.',
            errorSeverity: config.simple!,
          ),
        PrefixedIdentifier() when config.prefixedIdentifier != null => LintCode(
            name: 'prefixed_identifier',
            problemMessage: config.enableSuggestions
                ? 'Avoid using prefixed identifiers for string values in widgets. '
                    'Consider using localization methods or passing string values through constructor parameters.'
                : 'Prefixed identifier is not allowed.',
            errorSeverity: config.prefixedIdentifier!,
          ),
        StringInterpolation() when config.interpolation != null => LintCode(
            name: 'string_interpolation',
            problemMessage: config.enableSuggestions
                ? 'Avoid using string interpolation in widgets. '
                    'Consider using localization methods with parameters like AppLocalizations.of(context).greetingWithName(name).'
                : 'String interpolation is not allowed.',
            errorSeverity: config.interpolation!,
          ),
        BinaryExpression() when config.binary != null => LintCode(
            name: 'binary_expression',
            problemMessage: config.enableSuggestions
                ? 'Avoid using string concatenation with binary operators in widgets. '
                    'Consider using localization methods or string templates.'
                : 'Binary expression is not allowed.',
            errorSeverity: config.binary!,
          ),
        AdjacentStrings() when config.adjacent != null => LintCode(
            name: 'adjacent_strings',
            problemMessage: config.enableSuggestions
                ? 'Avoid using adjacent string literals in widgets. '
                    'Consider using localization methods or a single string constant.'
                : 'Adjacent strings are not allowed.',
            errorSeverity: config.adjacent!,
          ),
        MethodInvocation() when config.method != null => LintCode(
            name: 'method_invocation',
            problemMessage: config.enableSuggestions
                ? 'Avoid using method invocations for string values in widgets. '
                    'Consider using proper localization methods like AppLocalizations.of(context).yourKey.'
                : 'Method invocation is not allowed.',
            errorSeverity: config.method!,
          ),
        SimpleIdentifier() when config.simpleIdentifier != null => LintCode(
            name: 'simple_identifier',
            problemMessage: config.enableSuggestions
                ? 'Avoid using simple identifiers for string values in widgets. '
                    'Consider using localization methods or ensuring the identifier represents a localized string.'
                : 'Simple identifier is not allowed.',
            errorSeverity: config.simpleIdentifier!,
          ),
        FunctionExpressionInvocation() when config.function != null => LintCode(
            name: 'function_invocation',
            problemMessage: config.enableSuggestions
                ? 'Avoid using function expression invocations for string values in widgets. '
                    'Consider using localization methods or predefined string constants.'
                : 'Function expression invocation is not allowed.',
            errorSeverity: config.function!,
          ),
        NamedExpression(:Expression expression) => _checkValue(expression),
        _ => null,
      };
}
