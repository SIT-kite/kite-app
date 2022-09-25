final _htmlRegex = RegExp(r"<([A-Za-z][A-Za-z0-9]*)\b[^>]*>(.*?)<\/\1>");

bool guessIsHtml(String raw) {
  return _htmlRegex.hasMatch(raw);
}
