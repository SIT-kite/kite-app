enum ExpenseType {
  /// 食堂
  canteen,

  /// 大活咖啡吧
  coffee,

  /// 热水
  water,

  /// 洗澡
  shower,

  /// 超市
  store,

  /// 未知
  unknown,
}

class ExpenseDetail {
  /// 消费地点
  final String place;

  /// 消费时间
  final DateTime ts;

  /// 消费金额
  final double amount;

  /// 消费类型
  final ExpenseType type;

  const ExpenseDetail(this.place, this.ts, this.amount, this.type);
}

const expenseTypeMapping = {
  ExpenseType.canteen: '食堂',
  ExpenseType.coffee: '咖啡吧',
  ExpenseType.water: '热水',
  ExpenseType.shower: '洗浴',
  ExpenseType.store: '商店',
  ExpenseType.unknown: '未知',
};
