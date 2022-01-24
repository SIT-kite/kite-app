import 'package:kite/dao/expense.dart';
import 'package:kite/entity/expense.dart';
import 'package:hive/hive.dart';

class ExpenseLocalStorage implements ExpenseLocalDao {
  final Box<ExpenseRecord> box;
  const ExpenseLocalStorage(this.box);

  @override
  void add(ExpenseRecord record) {
    box.put(record.ts.hashCode, record);
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys.map((e) => e.hashCode));
  }

  @override
  List<ExpenseRecord> getAllByTimeDesc() {
    var result = box.values.toList();
    result.sort((a, b) => b.ts.compareTo(a.ts));
    return result;
  }
}
