import 'commands/command.dart';

enum TargetSelectorType {
  anyPlayer,
  executor,
  anyEntity,
}

enum TargetSelectorSort {
  random,
  nearest,
  furthest,
  arbitrary,
}

class TargetSelector {
  TargetSelectorType type;
  int? minimumDistance;
  int? maximumDistance;
  TargetSelectorSort? sort;
  int? limit;
  Point? startPoint;
  Point? volume;

  TargetSelector(this.type);

  setDistance(int minimum, int maximum) {
    minimumDistance = minimum;
    maximumDistance = maximum;
  }

  setPosition(Point point) {
    startPoint = point;
  }

  setRect(Point startPoint, Point endPoint) {
    this.startPoint = startPoint;
    volume = Point(endPoint.x - startPoint.x, endPoint.y - startPoint.y,
        endPoint.z - startPoint.z);
  }

  @override
  String toString() {
    String selector;
    switch (type) {
      case TargetSelectorType.executor:
        {
          selector = "@s";
          break;
        }
      case TargetSelectorType.anyPlayer:
        {
          selector = "@a";
          break;
        }
      case TargetSelectorType.anyEntity:
        {
          selector = "@e";
          break;
        }
    }

    List<String> options = [];
    if (minimumDistance != null || maximumDistance != null) {
      options.add("distance=$minimumDistance..$maximumDistance");
    }

    if (startPoint != null) {
      options.add("x=${startPoint!.x}");
      options.add("y=${startPoint!.y}");
      options.add("z=${startPoint!.z}");
    }

    if (volume != null) {
      options.add("dx=${volume!.x}");
      options.add("dy=${volume!.y}");
      options.add("dz=${volume!.z}");
    }

    if (sort != null) {
      options.add("sort=${sort.toString()}");
    }

    if (limit != null) {
      options.add("limit=$limit");
    }

    return "$selector[${options.join(",")}]";
  }
}
