import 'package:kite/module/expense2/entity/local.dart';

import '../dao/local.dart';

class ExpenseStorage implements ExpenseLocalDao {
  @override
  void add(Transaction record) {
    // TODO: implement add
  }

  @override
  void addAll(Iterable<Transaction> records) {
    // TODO: implement addAll
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  // TODO: implement isEmpty
  bool get isEmpty => throw UnimplementedError();

  @override
  // TODO: implement last
  Transaction? get last => throw UnimplementedError();

}
