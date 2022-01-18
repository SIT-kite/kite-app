import 'package:kite/entity/expense.dart';

/// 测试数据
List<ExpenseDetail> mockedData = [
  ExpenseDetail('奉贤教工食堂一层9#', DateTime(2021, 12, 18, 12, 00, 03), 10, ExpenseType.canteen),
  ExpenseDetail('六角亭勇阳超市2(192.168.16.39)', DateTime(2021, 12, 17, 12, 00, 03), 10, ExpenseType.store),
  ExpenseDetail('奉贤教工食堂一层15#', DateTime(2021, 12, 16, 12, 00, 03), 10, ExpenseType.canteen),
  ExpenseDetail('六角亭勇阳超市2(192.168.16.39)', DateTime(2021, 12, 17, 12, 00, 03), 10, ExpenseType.store),
  ExpenseDetail('30号楼#12热水', DateTime(2021, 12, 15, 12, 00, 03), 10, ExpenseType.shower),
  ExpenseDetail('30号楼#12热水', DateTime(2021, 10, 5, 12, 00, 03), 10, ExpenseType.shower),
  ExpenseDetail('30号楼#12热水', DateTime(2021, 10, 4, 12, 00, 03), 10, ExpenseType.shower),
  ExpenseDetail('30号楼#12热水', DateTime(2021, 9, 3, 12, 00, 03), 10, ExpenseType.shower),
  ExpenseDetail('30号楼#12热水', DateTime(2021, 9, 2, 12, 00, 03), 10, ExpenseType.shower),
];

List classificationData = [
  {'label': 'canteen', 'money': 100, 'percentage': 0.8},
  {'label': 'canteen', 'money': 100, 'percentage': 0.2},
];

Future<List<ExpenseDetail>> getMockedExpenseBill() async {
  await Future.delayed(const Duration(microseconds: 300));
  return mockedData;
}
