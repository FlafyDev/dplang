import 'dart:developer';

import '../minecraft/commands/command.dart';
import 'ast/ast.dart';
import 'ast/statements.dart';
import 'function_compiler.dart';

String compile(String code) {
  final functions = parseString(code);

  inspect(functions);

  String newCode = "";

  newCode += createObjective("values");
  var functionCompiler = FunctionCompiler(functions.first, "values");
  var compiledFunction = functionCompiler.compile();
  newCode += compiledFunction.code;

  print(compiledFunction.returned.name);

  return newCode;
}
