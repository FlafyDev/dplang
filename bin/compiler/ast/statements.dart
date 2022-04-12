import 'package:analyzer/dart/ast/ast.dart' as dart_ast;

import 'expressions.dart';
import 'value_type.dart';

abstract class Statement {
  static Statement fromDart(dart_ast.Statement statement) {
    if (statement is dart_ast.VariableDeclarationStatement) {
      if (statement.variables.variables.length != 1) {
        throw Exception("Can't declare more than 1 variable.");
      }
      statement = statement as dart_ast.VariableDeclarationStatement;

      return VariableDeclarationStatement(
          Variable(
              stringToValueType(
                  (statement.variables.type as dart_ast.NamedType).name.name),
              statement.variables.variables.first.name.name),
          Expression.fromDart(
              statement.variables.variables.first.initializer!));
    } else if (statement is dart_ast.ExpressionStatement) {
      if (statement.expression is dart_ast.AssignmentExpression) {
        var expression =
            (statement.expression as dart_ast.AssignmentExpression);

        if (expression.operator.lexeme != "=") {
          throw Exception("Unsupported assignment.");
        }

        return VariableAssignmentStatement(
            (expression.leftHandSide as dart_ast.SimpleIdentifier).name,
            Expression.fromDart(expression.rightHandSide));
      } else {
        return ExpressionStatement(Expression.fromDart(statement.expression));
      }
    } else if (statement is dart_ast.ReturnStatement) {
      return ReturnStatement(statement.expression != null
          ? Expression.fromDart(statement.expression!)
          : null);
    } else {
      throw Exception("Unknown statement.");
    }
  }
}

class VariableDeclarationStatement extends Statement {
  Variable variable;
  Expression initializer;
  VariableDeclarationStatement(this.variable, this.initializer);
}

class VariableAssignmentStatement extends Statement {
  String variableName;
  Expression expression;
  VariableAssignmentStatement(this.variableName, this.expression);
}

class ExpressionStatement extends Statement {
  Expression expression;
  ExpressionStatement(this.expression);
}

class ReturnStatement extends Statement {
  Expression? expression;
  ReturnStatement(this.expression);
}
