import 'package:hive/hive.dart';
import 'package:kite/global/hive_type_id_pool.dart';

part 'meta.g.dart';

/// 存放课表元数据
@HiveType(typeId: HiveTypeIdPool.timetableMetaItem)
class TimetableMeta extends HiveObject {
  /// 课表名称
  @HiveField(0)
  String name = '';

  /// 课表描述
  @HiveField(1)
  String description = '';

  /// 课表的起始时间
  @HiveField(2)
  DateTime startDate = DateTime.now();

  /// 学年
  @HiveField(3)
  int schoolYear = 0;

  /// 学期
  @HiveField(4)
  int semester = 0;

  @override
  String toString() {
    return 'TimetableMeta{name: $name, description: $description, startDate: $startDate, schoolYear: $schoolYear, semester: $semester}';
  }
}
