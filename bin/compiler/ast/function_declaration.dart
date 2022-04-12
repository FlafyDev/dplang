import 'package:analyzer/dart/ast/ast.dart' as dart_ast;

import 'statements.dart' as dp_ast;
import 'expressions.dart' as dp_ast;
import 'value_type.dart' as dp_ast;

class FunctionDeclaration {
  final String methodName;
  final dp_ast.ValueType returnType;
  final List<dp_ast.Variable> parameters;
  final List<dp_ast.Statement> statements = [];

  FunctionDeclaration(dart_ast.FunctionDeclaration func)
      : returnType = dp_ast.stringToValueType(
            (func.returnType as dart_ast.NamedType).name.name),
        parameters = (func.functionExpression.parameters?.parameters
                    .cast<dart_ast.SimpleFormalParameter>())
                ?.map((param) => dp_ast.Variable.findType(
                    (param.type as dart_ast.NamedType).name.name,
                    param.identifier!.name))
                .toList() ??
            [],
        methodName = func.name.name {
    final blockStatements =
        (func.functionExpression.body as dart_ast.BlockFunctionBody)
            .block
            .statements;
    for (var statement in blockStatements) {
      statements.add(dp_ast.Statement.fromDart(statement));
    }
  }
}
