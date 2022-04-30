import 'dart:developer';

import '../minecraft/commands/command.dart';
import 'ast/ast.dart';
import 'ast/statements.dart';
import 'function_compiler.dart';

class Compiler {
  final String namespace;
  final String objectiveName;
  final Map<String, String> resultedFiles = {};

  Compiler(this.namespace) : objectiveName = "_$namespace.values";

  void addCode(String code) {
    List<CompiledFunction> compiledFunctions = [];

    for (var function in parseString(code)) {
      var functionCompiler = FunctionCompiler(
        function,
        objectiveName,
        compiledFunctions,
      );
      var compiledFunction = functionCompiler.compile();
      compiledFunction.filePath =
          FunctionFilePath(namespace, [compiledFunction.methodName]);

      resultedFiles[compiledFunction.filePath.toString()] =
          compiledFunction.code;

      // TODO children function.

      compiledFunctions.add(compiledFunction);
    }
  }
}

// String compile(String namespace, String code) {
//   final functions = parseString(code);

//   for (var function in functions) {
//     var functionCompiler = FunctionCompiler(
//       function,
//       "values",
//       compiledFunctions,
//     );

//     compiledFunctions.add(functionCompiler.compile());
//     newCode += "\n\n" + compiledFunctions.last.code;
//   }

//   return newCode;
// }
