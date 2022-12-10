import '../using.dart';

part 'user_type.g.dart';
@HiveType(typeId: HiveTypeId.userType)

enum UserType2 {
  /// 本、专科生（10位学号）
  @HiveField(0)
  undergraduate,

  /// 研究生（9位学号）
  @HiveField(1)
  postgraduate,

  /// 教师（4位工号）
  @HiveField(2)
  teacher,

  /// 未入学的新生
  @HiveField(3)
  freshman,

  /// Offline Mode
  @HiveField(4)
  offline,
}
