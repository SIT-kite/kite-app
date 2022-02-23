import 'package:kite/entity/sc/join.dart';

abstract class ScJoinActivityDao {
  Future<String> process(ScJoinActivity item);
}
