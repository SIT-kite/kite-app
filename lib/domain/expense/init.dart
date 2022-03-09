import 'package:hive/hive.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/domain/expense/service/expense.dart';

import 'dao/expense.dart';
import 'entity/expense.dart';
import 'storage/expense.dart';

class ExpenseInitializer {
  static late ExpenseRemoteDao expenseRemote;
  static late ExpenseLocalStorage expenseRecord;

  static Future<void> init({
    required ASession ssoSession,
    required Box<ExpenseRecord> expenseRecordBox,
  }) async {
    expenseRecord = ExpenseLocalStorage(expenseRecordBox);

    expenseRemote = ExpenseRemoteService(ssoSession);
  }
}
