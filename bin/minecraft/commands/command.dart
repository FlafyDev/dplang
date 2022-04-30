import '../../compiler/ast/expressions.dart';
import '../../compiler/ast/value_type.dart';
import '../entity.dart';
import '../item.dart';

class Point {
  int x;
  int y;
  int z;
  Point(this.x, this.y, this.z);
}

class Tick {
  static int fromSeconds(int seconds) {
    return seconds * 20;
  }

  static int fromDays(int days) {
    return days * 24000;
  }
}

abstract class Argument {
  @override
  String toString();
}

class Coordinates extends Argument {
  Point point;
  Coordinates(this.point);

  @override
  String toString() {
    return "${point.x} ${point.y} ${point.z}";
  }
}

String setTime(int ticks) {
  return "time set ${ticks}t\n";
}

String giveItem(TargetSelector target, Item item) {
  return "give ${target.toString()} ${item.toString()}\n";
}

String createObjective(String name) {
  return "scoreboard objectives add $name dummy\n";
}

class FunctionFilePath {
  String namespace;
  List<String> path;
  FunctionFilePath(this.namespace, this.path);

  @override
  String toString() {
    return "$namespace:${path.join("/")}.mcfunction";
  }
}

String callFunction(FunctionFilePath path) {
  return "function ${path.namespace}:${path.path.join("/")}";
}

class TellrawStyle {
  bool bold = false;
  bool italic = false;
  bool underlined = false;
  bool strikeThrough = false;
  bool obfuscated = false;
  Color color;
  String font = "minecraft:default";
  
}

abstract class TellrawParameter {
  Map<String, dynamic> values = 

  @override
  String toString() {
    return values.toString();
  }
}

class TellrawText extends TellrawParameter {
  String text;
  TellrawText(this.text);
}

String tellraw(List<TellrawParameter> params) {}

class Score {
  String name;
  String objective;
  ValueType? type;
  Score(this.name, this.objective, [this.type]);

  setValue(String value) {
    return "scoreboard players set $name $objective $value\n";
  }

  getValue(String value) {
    return "scoreboard players get $name $objective $value\n";
  }

  setValueFromScore(Score score) {
    type = score.type;
    return _operation(score, "=");
  }

  add(Score score) {
    return _operation(score, "+=");
  }

  subtract(Score score) {
    return _operation(score, "-=");
  }

  multiple(Score score) {
    return _operation(score, "*=");
  }

  divide(Score score) {
    return _operation(score, "/=");
  }

  modulo(Score score) {
    return _operation(score, "%=");
  }

  _operation(Score score, String operation) {
    return "scoreboard players operation $name $objective $operation ${score.name} ${score.objective}\n";
  }
}

// String setScore(Score score, String value) {
//   return "scoreboard players set ${score.name} ${score.objective} $value\n";
// }

// String getScore(Score score, String value) {
//   return "scoreboard players get ${score.name} ${score.objective} $value\n";
// }

// String manipulateScore(Score targetScore, Operator op, Score sourceScore) {
//   String opStr;
//   switch (op) {
//     case Operator.add:
//       opStr = "+=";
//       break;
//     case Operator.subtract:
//       opStr = "-=";
//       break;
//     case Operator.divide:
//       opStr = "/=";
//       break;
//     case Operator.multiple:
//       opStr = "*=";
//       break;
//     case Operator.mod:
//       opStr = "%=";
//       break;
//     case Operator.power:
//       throw Exception("Unsupported operations");
//   }

//   return "scoreboard players operation ${targetScore.name} ${targetScore.objective} $opStr ${sourceScore.name} ${sourceScore.objective}\n";
// }
