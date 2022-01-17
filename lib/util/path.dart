class Path {
  late String _path;
  late String separator;
  Path({String base = '', this.separator = '/'}) {
    _path = base;
  }

  Path forward(String nextName) {
    return Path(
      base: toString() + separator + nextName,
      separator: separator,
    );
  }

  Path backward() {
    return Path(
      separator: separator,
      base: _path.substring(0, _path.lastIndexOf(separator)),
    );
  }

  @override
  String toString() {
    return _path;
  }
}
