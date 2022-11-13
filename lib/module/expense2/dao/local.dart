import '../entity/local.dart';

abstract class ExpenseLocalDao {
  void add(Transaction record);
  void addAll(Iterable<Transaction> records);
  Transaction? get last;
  void clear();
  bool get isEmpty;
}