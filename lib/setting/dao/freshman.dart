import 'package:kite/feature/freshman/entity.dart';

abstract class FreshmanCacheDao {
  Analysis? analysis;
  FreshmanInfo? basicInfo;
  List<Mate>? classmates;
  List<Mate>? roommates;
  List<Familiar>? familiars;

  /// 新生账户
  String? freshmanAccount;

  /// 新生账户
  String? freshmanSecret;

  /// 新生姓名
  String? freshmanName;
}
