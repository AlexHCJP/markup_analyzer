import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';

mixin WidgetCheckerMixin {
  bool isWidgetType(DartType? type) {
    if (type is! InterfaceType) return false;
    return [type, ...type.allSupertypes].any((t) => t.element.name == 'Widget');
  }

  bool isWidgetConstructorCall(AstNode? node) {
    if (node is! InstanceCreationExpression) return false;
    return isWidgetType(node.staticType);
  }
}
