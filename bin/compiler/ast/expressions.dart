import 'value_type.dart';
import 'package:analyzer/dart/ast/ast.dart' as dart_ast;

enum Operator {
  add,
  subtract,
  divide,
  multiple,
  power,
  modulo,
}

abstract class Expression {
  static Expression fromDart(dart_ast.Expression expression) {
    if (expression is dart_ast.IntegerLiteral) {
      return Value(ValueType.int, expression.value.toString());
    } else if (expression is dart_ast.DoubleLiteral) {
      switch (expression.literal.lexeme.split(".")[1].length) {
        case 2:
          {
            return Value(ValueType.fixed2, expression.value.toString());
          }
        default:
          {
            throw Exception("Unknown fixed point number scale.");
          }
      }
    } else if (expression is dart_ast.SimpleIdentifier) {
      return Variable(null, expression.name);
    } else if (expression is dart_ast.BinaryExpression) {
      return BinaryExpression(
          stringToOperator(expression.operator.lexeme),
          Expression.fromDart(expression.leftOperand),
          Expression.fromDart(expression.rightOperand));
    } else if (expression is dart_ast.MethodInvocation) {
      return CallExpression(
          expression.methodName.name,
          expression.argumentList.arguments
              .map((arg) => Expression.fromDart(arg))
              .toList());
    } else {
      throw Exception("Unknown expression.");
    }
  }
}

class Value extends Expression {
  ValueType type;
  String value;
  Value(this.type, this.value);
}

class Variable extends Expression {
  ValueType? type;
  String name;

  Variable(this.type, this.name);
  Variable.findType(String typeName, this.name)
      : type = stringToValueType(typeName);
}

class BinaryExpression extends Expression {
  Expression left;
  Expression right;
  Operator op;
  BinaryExpression(this.op, this.left, this.right);
}

class CallExpression extends Expression {
  String methodName;
  List<Expression> arguments;
  CallExpression(this.methodName, this.arguments);
}

Operator stringToOperator(String op) {
  switch (op.trim()) {
    case "+":
      return Operator.add;
    case "-":
      return Operator.subtract;
    case "*":
      return Operator.multiple;
    case "/":
      return Operator.divide;
    case "%":
      return Operator.modulo;
    case "^":
      return Operator.power;
    default:
      throw Exception("Unknown operator.");
  }
}
