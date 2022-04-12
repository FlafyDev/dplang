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

  String code = """
    int main(fixed2 a) {
      int x = "2";
      // int y = 2;
      // x = x + 1;
      // int z = x*y+2/1;
      // int h = 4*asd(2, 4.00, z)+2/y;
      // print(x*3+y);
      return 123;
    }
    """;

  print(compile(code));
//   var code = """
// 232 + 5 * (3 + 2 * 21) ^ 3 * 2
// """;

  // print(compile(code));
}
