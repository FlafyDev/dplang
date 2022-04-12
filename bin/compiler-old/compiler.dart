// import "dart:math";
// // import "package:math_expressions/math_expressions.dart";

// class Stack<E> {
//   final _list = <E>[];

//   void push(E value) => _list.add(value);

//   E pop() => _list.removeLast();

//   E get peek => _list.last;

//   bool get isEmpty => _list.isEmpty;
//   bool get isNotEmpty => _list.isNotEmpty;

//   @override
//   String toString() => _list.toString();
// }

// List<Token> tokenize(String code) {}

// String compile(String code) {
//   // var tokens = tokenize(code);

//   // print("[${tokens.join(", ")}]");

//   var tokenized = Parser().lex.tokenizeToRPN(code);

//   print(tokenized);

//   var values = Stack<int>();

//   for (Token token in tokenized) {
//     if (token.type == TokenType.VAR || token.type == TokenType.VAL) {
//       values.push(int.parse(token.text));
//       print(values);
//     } else {
//       switch (token.type) {
//         case TokenType.PLUS:
//           values.push(values.pop() + values.pop());
//           break;
//         case TokenType.MINUS:
//           values.push(values.pop() - values.pop());
//           break;
//         case TokenType.TIMES:
//           values.push(values.pop() * values.pop());
//           break;
//         case TokenType.DIV:
//           values.push((values.pop() / values.pop()).round());
//           break;
//         case TokenType.POW:
//           values.push(pow(values.pop(), values.pop()).round());
//           break;
//       }
//     }
//   }

//   print(values.pop());

//   return code;
// }
