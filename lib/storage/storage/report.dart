import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/storage/dao/report.dart';

class ReportKeys {
  static const namespace = '/report';
  static const enable = '$namespace/enable';
  static const time = '$namespace/time';
}

class ReportStorage implements ReportStorageDao {
  final Box<dynamic> box;

  ReportStorage(this.box);

  @override
  bool? get enable => box.get(ReportKeys.enable);
  @override
  set enable(bool? val) => box.put(ReportKeys.enable, val);

  @override
  DateTime? get time => box.get(ReportKeys.time);
  @override
  set time(DateTime? val) => box.put(ReportKeys.time, val);
}
