import 'package:kite/entity/expense.dart';

/// 远程的消费数据访问层的接口
abstract class ExpenseRemoteDao {
  /// 获取消费
  Future<ExpensePage> getExpensePage(int pageNum,
      {DateTime start, DateTime end});
}

/// 本地的消费数据访问接口
abstract class ExpenseLocalDao {
  /// 添加消费记录
  void add(ExpenseRecord record);

  /// 获取最近一次消费记录 (首页)
  ExpenseRecord? getLastOne();

  /// 清空消费记录存储
  void deleteAll();

  /// 获取所有消费记录
  List<ExpenseRecord> getAllByTimeDesc();

  /// 判断是否存在该记录
  bool isEmpty(DateTime ts);
}
