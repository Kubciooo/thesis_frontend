/// funkcja zamieniająca spację na znaki %20
String parseName(String name) {
  String parsed = name.replaceAll(" ", '%20');
  return parsed;
}
