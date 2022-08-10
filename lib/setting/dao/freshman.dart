import 'package:kite/feature/freshman/entity.dart';

abstract class FreshmanCacheDao {
  Analysis? analysis;
  FreshmanInfo? basicInfo;
  List<Mate>? classmates;
  List<Mate>? roommates;
  List<Familiar>? familiars;
}
