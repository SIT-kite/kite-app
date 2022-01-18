import 'package:kite/entity/expense.dart';

/// 消费数据访问层的接口
abstract class ExpenseDao {
  /// 获取消费
  Future<ExpensePage> getExpensePage(int pageNum, {DateTime start, DateTime end});
}
