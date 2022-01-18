import 'package:kite/entity/expense.dart';

/// 远程的消费数据访问层的接口
abstract class ExpenseRemoteDao {
  /// 获取消费
  Future<ExpensePage> getExpensePage(int pageNum, {DateTime start, DateTime end});
}

/// 本地的消费数据访问接口
abstract class ExpenseLocalDao {
  /// 添加消费记录
  void addAll(List<ExpenseRecord> records);
}
