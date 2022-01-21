import 'package:kite/service/electricity.dart';

String getCharge(List<dynamic> list) {
  double charge = 0.0;
  for (var item in list) {
    charge = item.charge > charge ? item.charge : charge;
  }
  return charge.toStringAsFixed(2);
}

Future<Map<String, double>> getRank(String room) => fetchRank(room).then((res) {
      final percentage = double.parse(((res.roomCount - res.rank) / res.roomCount * 100).toStringAsFixed(2));
      return {'consumption': res.consumption, 'percentage': percentage};
    });
