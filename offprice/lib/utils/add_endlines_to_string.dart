/// funkcja pomocnicza do dodawania znaków endline do tekstu co określoną liczbę znaków w linii
String addEndlinesToString(String str, int maxLength) {
  String result = "";
  List<String> words = str.split(" ");

  int currentLineLength = 0;
  for (int i = 0; i < words.length; i++) {
    String word = words[i];
    if (currentLineLength + word.length > maxLength) {
      result += "\n" + word;
      currentLineLength = word.length;
    } else {
      result += " " + word;
      currentLineLength += word.length + 1;
    }
  }

  return result;
}
