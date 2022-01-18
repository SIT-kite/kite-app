/// 消费类型
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

/// 消费记录
class ExpenseRecord {
  /// 学号
  String username = '';

  /// 姓名
  String name = '';

  /// 消费地点
  String place = '';

  /// 消费时间
  DateTime ts = DateTime.now();

  /// 消费金额
  double amount = 0.0;

  /// 消费类型
  ExpenseType type = ExpenseType.unknown;

  @override
  String toString() {
    return 'ExpenseRecord{username: $username, name: $name, place: $place, ts: $ts, amount: $amount, type: ${expenseTypeMapping[type]}}';
  }
}

/// 消费类型枚举与文字的映射表
const expenseTypeMapping = {
  ExpenseType.canteen: '食堂',
  ExpenseType.coffee: '咖啡吧',
  ExpenseType.water: '热水',
  ExpenseType.shower: '洗浴',
  ExpenseType.store: '商店',
  ExpenseType.unknown: '其他',
};

/// 爬虫获得的消费页
class ExpensePage {
  /// 当前页号
  int currentPage = 1;

  /// 总页数
  int total = 10;

  /// 该页的记录数
  List<ExpenseRecord> records = [];

  @override
  String toString() {
    return 'ExpensePage{currentPage: $currentPage, total: $total, records: $records}';
  }
}
