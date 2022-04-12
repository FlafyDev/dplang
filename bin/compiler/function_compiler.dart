import 'package:nanoid/nanoid.dart';

import '../minecraft/commands/command.dart';
import 'ast/expressions.dart';
import 'ast/function_declaration.dart';
import 'ast/statements.dart';
import 'ast/value_type.dart';

class CompiledExpression {
  String code;
  Score? returnedScore;
  CompiledExpression(this.code, [this.returnedScore]);
}

class CompiledStatement {
  String code;
  bool returned;
  CompiledStatement(this.code, [this.returned = false]);
}

class CompiledFunction {
  String methodName;
  List<Score> parameters;
  Score returned;
  String code;
  CompiledFunction(this.methodName, this.parameters, this.code, this.returned);
}

class FunctionCompiler {
  FunctionDeclaration func;
  String objective;

  late CompiledFunction _compiledFunction;
  late Map<String, Score> _variables;
  late String _prefix;

  FunctionCompiler(this.func, this.objective);

  CompiledFunction compile() {
    _prefix = nanoid(5);
    _variables = {};

    int counter = 0;
    List<Score> scoreParameters = [];
    for (var param in func.parameters) {
      var score = Score(_generateScoreName(counter++), objective);
      score.type = param.type;
      _variables[param.name] = score;
      scoreParameters.add(score);
    }

    _compiledFunction = CompiledFunction(func.methodName, scoreParameters, "",
        Score(_generateScoreName(counter++), objective));
    _compiledFunction.returned.type = func.returnType;

    for (var statement in func.statements) {
      var compiledStatement = compileStatement(statement);
      _compiledFunction.code += compiledStatement.code;
      if (compiledStatement.returned) {
        break;
      }
    }

    return _compiledFunction;
  }

  CompiledExpression compileExpression(Expression expression) {
    final compiledExpression = CompiledExpression("");
    _prefix = nanoid(5);

    if (expression is Value) {
      var score = Score(_generateScoreName(0), objective);
      compiledExpression.code += score.setValue(expression.value);
      score.type = expression.type;
      compiledExpression.returnedScore = score;
    } else if (expression is Variable) {
      var variableScore = _variables[expression.name];
      if (variableScore == null) {
        throw Exception("Used variable before initialization");
      }

      compiledExpression.returnedScore = variableScore;
    } else if (expression is BinaryExpression) {
      var left = compileExpression(expression.left);
      var right = compileExpression(expression.right);

      if (left.returnedScore?.type == null ||
          left.returnedScore?.type != right.returnedScore?.type) {
        throw Exception("Types don't match.");
      }

      compiledExpression.code += left.code;
      compiledExpression.code += right.code;

      switch (expression.op) {
        case Operator.add:
          left.returnedScore!.add(right.returnedScore!);
          break;
        case Operator.subtract:
          left.returnedScore!.subtract(right.returnedScore!);
          break;
        case Operator.divide:
          left.returnedScore!.divide(right.returnedScore!);
          break;
        case Operator.multiple:
          left.returnedScore!.multiple(right.returnedScore!);
          break;
        case Operator.modulo:
          left.returnedScore!.modulo(right.returnedScore!);
          break;
        case Operator.power:
          throw Exception("Unsupported operations");
      }
      compiledExpression.returnedScore = left.returnedScore!;
    } else if (expression is CallExpression) {
      throw Exception();
    } else {
      throw Exception("Unknown Expression.");
    }

    return compiledExpression;
  }

  CompiledStatement compileStatement(Statement statement) {
    if (statement is VariableDeclarationStatement) {
      var compiledExpression = compileExpression(statement.initializer);

      if (compiledExpression.returnedScore == null ||
          compiledExpression.returnedScore?.type != statement.variable.type) {
        throw Exception("Types don't match.");
      }

      if (_variables.containsKey(statement.variable.name)) {
        throw Exception("Can't override variable.");
      }

      _variables[statement.variable.name] = compiledExpression.returnedScore!;

      return CompiledStatement(compiledExpression.code);
    } else if (statement is VariableAssignmentStatement) {
      var compiledExpression = compileExpression(statement.expression);

      var variable = _variables[statement.variableName];

      if (variable == null) {
        throw Exception("Can't assign to variable before initialization.");
      }

      if (compiledExpression.returnedScore == null ||
          compiledExpression.returnedScore?.type != variable.type) {
        throw Exception("Types don't match.");
      }

      variable = compiledExpression.returnedScore!;

      return CompiledStatement(compiledExpression.code);
    } else if (statement is ReturnStatement) {
      if (func.returnType == ValueType.none) {
        if (statement.expression != null) {
          throw Exception(
              "Return must be empty with function return type as void.");
        }
        return CompiledStatement("", true);
      }

      if (statement.expression == null) {
        throw Exception(
            "Return value doesn't match the function's return value.");
      }

      var compiledExpression = compileExpression(statement.expression!);

      if (compiledExpression.returnedScore?.type != func.returnType) {
        throw Exception(
            "Return value doesn't match the function's return value.");
      }

      return CompiledStatement(
          compiledExpression.code +
              _compiledFunction.returned
                  .setValueFromScore(compiledExpression.returnedScore!),
          true);
    } else {
      throw Exception("Unknown Statement.");
    }
  }

  String _generateScoreName(int id) {
    return "$_prefix$id";
  }
}
