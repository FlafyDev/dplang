enum ValueType {
  none,
  int,
  fixed2,
}

ValueType stringToValueType(String type) {
  switch (type) {
    case "void":
      {
        return ValueType.none;
      }
    case "int":
      {
        return ValueType.int;
      }
    case "fixed2":
      {
        return ValueType.fixed2;
      }
    default:
      {
        throw Exception("Unknown type");
      }
  }
}
