import 'package:kite/domain/expense/service/expense.dart';
import 'package:kite/session/abstract_session.dart';

import 'dao/expense.dart';

class ExpenseInitializer {
  static late ExpenseRemoteDao expenseRemote;
  static init(ASession session) {
    expenseRemote = ExpenseRemoteService(session);
  }
}
