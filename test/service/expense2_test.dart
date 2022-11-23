import 'package:dio/dio.dart';
import 'package:kite/mock/index.dart';
import 'package:kite/module/expense2/service/getter.dart';
import 'package:kite/session/dio_common.dart';

void main() async {
  final session = DefaultDioSession(Dio());
  test('expense_tracker2 test', () async {
    final expense = await ExpenseGetService(session).fetch(
      studentID: '1910400401',
      from: DateTime(2010),
      to: DateTime.now(),
    );
    Log.info(expense);
  });
}
