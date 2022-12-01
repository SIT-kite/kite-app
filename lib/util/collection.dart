extension StreamEx<T> on Iterable<T> {
  List<R> mapIndexed<R>(R Function(T e, int i) map) {
    List<R> res = [];
    int index = 0;
    for (T e in this) {
      res.add(map(e, index));
      index += 1;
    }
    return res;
  }
}
