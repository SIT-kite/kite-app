import 'local.dart';
import 'shared.dart';

class Page {
  DateTime month = defaultDateTime;
  List<Transaction> descending = [];

  bool get isEmpty => descending.isEmpty;
}

class Pages {
  List<Page> descending = [];
  bool get isEmpty => descending.isEmpty;
}
