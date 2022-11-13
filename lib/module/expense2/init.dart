import 'service/getter.dart';
import 'using.dart';
import 'dao/getter.dart';
import 'storage/local.dart';

class Expense2Init {
  static late ExpenseGetDao remote;
  static late ExpenseStorage local;

  static void init({
    required ISession session,
  }) {
    remote = ExpenseGetService();
  }
}
