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
  late FunctionFilePath filePath;
  String methodName;
  List<Score> parameters;
  Score returned;
  String code;
  CompiledFunction(this.methodName, this.parameters, this.code, this.returned);
}

class FunctionCompiler {
  FunctionDeclaration functionDeclaration;
  String objective;
  List<CompiledFunction> accessibleFunctions;

  late CompiledFunction _compiledFunction;
  late Map<String, Score> _variables;

  FunctionCompiler(
      this.functionDeclaration, this.objective, this.accessibleFunctions);

  CompiledFunction compile() {
    _variables = {};
    var scoreNameGenerator = _createScoreNameGenerator();

    if (accessibleFunctions.any((accessibleFunction) =>
        accessibleFunction.methodName == functionDeclaration.methodName)) {
      throw Exception("Can't override an existing function.");
    }

    int counter = 0;
    List<Score> scoreParameters = [];
    for (var param in functionDeclaration.parameters) {
      var score = Score(scoreNameGenerator(counter++), objective);
      score.type = param.type;
      _variables[param.name] = score;
      scoreParameters.add(score);
    }

    _compiledFunction = CompiledFunction(functionDeclaration.methodName,
        scoreParameters, "", Score(scoreNameGenerator(counter++), objective));
    _compiledFunction.returned.type = functionDeclaration.returnType;

    for (var statement in functionDeclaration.statements) {
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
    var scoreNameGenerator = _createScoreNameGenerator();

    if (expression is Value) {
      var score = Score(scoreNameGenerator(0), objective);
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
      var resultScore =
          Score(scoreNameGenerator(0), objective, left.returnedScore!.type);
      compiledExpression.code +=
          resultScore.setValueFromScore(left.returnedScore!);

      switch (expression.op) {
        case Operator.add:
          compiledExpression.code += resultScore.add(right.returnedScore!);
          break;
        case Operator.subtract:
          compiledExpression.code += resultScore.subtract(right.returnedScore!);
          break;
        case Operator.divide:
          compiledExpression.code += resultScore.divide(right.returnedScore!);
          break;
        case Operator.multiple:
          compiledExpression.code += resultScore.multiple(right.returnedScore!);
          break;
        case Operator.modulo:
          compiledExpression.code += resultScore.modulo(right.returnedScore!);
          break;
        case Operator.power:
          throw Exception("Unsupported operations");
      }
      compiledExpression.returnedScore = resultScore;
    } else if (expression is CallExpression) {
      var function = accessibleFunctions.firstWhere((accessibleFunction) =>
          accessibleFunction.methodName == expression.methodName);

      var index = 0;
      for (var argExpression in expression.arguments) {
        var arg = compileExpression(argExpression);
        if (arg.returnedScore?.type != function.parameters[index].type) {
          throw Exception("Types don't match.");
        }

        compiledExpression.code += arg.code;
        compiledExpression.code +=
            function.parameters[index].setValueFromScore(arg.returnedScore!);

        index++;
      }

      compiledExpression.code += callFunction(function.filePath);
      compiledExpression.returnedScore =
          Score(scoreNameGenerator(0), objective);
      compiledExpression.code += compiledExpression.returnedScore!
          .setValueFromScore(function.returned);
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
      if (functionDeclaration.returnType == ValueType.none) {
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

      if (compiledExpression.returnedScore?.type !=
          functionDeclaration.returnType) {
        throw Exception(
            "Return value doesn't match the function's return value.");
      }

      return CompiledStatement(
          compiledExpression.code +
              _compiledFunction.returned
                  .setValueFromScore(compiledExpression.returnedScore!),
          true);
    } else if (statement is ExpressionStatement) {
      var compiledExpression = compileExpression(statement.expression);
      return CompiledStatement(compiledExpression.code);
    } else {
      throw Exception("Unknown Statement.");
    }
  }

  _createScoreNameGenerator() {
    var context = nanoid(5);
    return (int id) {
      return "$context$id";
    };
  }
}
