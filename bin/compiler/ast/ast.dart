import 'dart:developer';

import 'package:analyzer/dart/analysis/utilities.dart' as dart_ast;
import 'package:analyzer/dart/ast/ast.dart' as dart_ast;
import 'function_declaration.dart' as dp_ast;

List<dp_ast.FunctionDeclaration> parseString(String code) {
  final ast = dart_ast.parseString(content: code);

  inspect(ast);

  final List<dp_ast.FunctionDeclaration> functionDeclarations = [];

  for (final functionDeclaration
      in ast.unit.declarations.cast<dart_ast.FunctionDeclaration>()) {
    functionDeclarations.add(dp_ast.FunctionDeclaration(functionDeclaration));
  }

  return functionDeclarations;
}
