// import 'tokens.dart';
// import 'package:collection/collection.dart';

// enum TokenType {
//   intType,
//   fixedType,
//   variable,
//   value,
//   equals,
//   add,
//   subtract,
//   multiple,
//   divide,
//   endLine,
// }

// class Token<T> {
//   TokenType type;
//   String text;
//   Token(this.type, [this.text = ""]);
// }

// String compile(String code) {
//   List<Token> tokens = [];

//   var lines = code.split(";");

//   for (var line in lines) {
//     var splits = line.split(" ");
//     var action = splits.firstOrNull;

//     if (action == "int" || action == "fixed") {
//       if (action == "int") {
//         tokens.add(Token(TokenType.intType));
//       } else {
//         tokens.add(Token(TokenType.fixedType));
//       }

//       tokens.add(Token(TokenType.variable, line.split("=")[0]));

//       tokens.add(Token(TokenType.endLine));
//     }
//   }

//   for (var chr in code.runes) {
//     String chrStr = String.fromCharCode(chr);
//   }

//   return code;
// }
