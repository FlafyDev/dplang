// abstract class Token {}

// enum TokenType {
//   variable,
//   value,
//   equals,
// }

// enum ValueType {
//   integer,
//   fixedPointTwo,
// }

// class Functional extends Token {}

// class Code extends Token {}

// class Variable extends Functional {
//   String name;
//   Variable(this.name);
// }

// class Value extends Functional {
//   ValueType type;
//   Value(this.type);
// }

// // class Calculation extends Token {}

// class AssignmentStatement extends Code {
//   ValueType type;
//   Variable variable;
//   Functional init;
//   AssignmentStatement(this.type, this.variable, this.init);
// }

// // class CallStatement extends Code {
// //   Variable base;
// //   Functional arguments;
// //   CallStatement(this.base, this.arguments);
// // }

// // class Block extends Token {
// //   List<Code> body = [];
// //   Block();
// // }

// // class FunctionDeclaration extends Token {
// //   Variable name;
// //   Block block;
// //   FunctionDeclaration(this.name, this.block);
// // }
