import 'package:kite/service/electricity.dart';

String getCharge(List<ConditionDays> list) {
  double charge = 0.0;
  list.forEach((item) {
    charge = item.charge > charge ? item.charge : charge;
  });
  return charge.toStringAsFixed(2);
}
