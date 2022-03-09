import 'package:hive/hive.dart';
import 'package:kite/domain/expense/service/expense.dart';
import 'package:kite/abstract/abstract_session.dart';

import 'dao/expense.dart';
import 'entity/expense.dart';
import 'storage/expense.dart';

class ExpenseInitializer {
  static late ExpenseRemoteDao expenseRemote;
  static late ExpenseLocalStorage expenseRecord;

  static Future<void> init(ASession session) async {
    final expenseRecordBox = await Hive.openBox<ExpenseRecord>('expenseSetting');
    expenseRecord = ExpenseLocalStorage(expenseRecordBox);

    expenseRemote = ExpenseRemoteService(session);
  }
}
