import 'package:kite/entity/electricity.dart';
import 'package:kite/service/electricity.dart';

String getCharge(List<ConditionDays> list) {
  double charge = 0.0;
  list.forEach((item) {
    charge = item.charge > charge ? item.charge : charge;
  });
  return charge.toStringAsFixed(2);
}

Future<Map<String, dynamic>> getRank(String room) =>
    fetchRank(room).then((res) {
      final percentage = (res.rank / res.roomCount * 100).toStringAsFixed(2);
      return {'consumption': res.consumption, 'percentage': percentage};
    });
