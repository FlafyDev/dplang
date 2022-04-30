import 'dart:developer';

import 'compiler/ast/function_declaration.dart';
import 'compiler/compile.dart';

class FPOperations {
  int scale;
  FPOperations(this.scale);

  double toDouble(int num1) {
    return num1 / scale;
  }

  int fromDouble(double num1) {
    return (num1 * scale).round();
  }

  int add(int num1, int num2) {
    return num1 + num2;
  }

  int sub(int num1, int num2) {
    return num1 - num2;
  }

  int multi(int num1, int num2) {
    return num1 * num2 ~/ scale;
  }

  int div(int num1, int num2) {
    return num1 * scale ~/ num2;
  }
}

void main(List<String> arguments) {
  var fpo = FPOperations(100);

  int tfp1 = fpo.fromDouble(0.58); // 058
  int tfp2 = fpo.fromDouble(0.24); // 024

  int tfp3 = fpo.div(tfp1, tfp2);

  print(fpo.toDouble(tfp3));

  String namespace = "flafy";
  String code = """
    // int sum(int a, int b, int c) {
    //   return a + b + c;
    // }
    void main() {
      // int h = sum(1*32,2*1,3/3);
      (123);
      // if (h == 1) {

      // }
    }
    """;

  var compiler = Compiler(namespace);
  compiler.addCode(code);

  compiler.resultedFiles.forEach((key, value) {
    print("FILE: $key");
    print(value);
  });
//   var code = """
// 232 + 5 * (3 + 2 * 21) ^ 3 * 2
// """;

  // print(compile(code));
}
