import 'package:kite/entity/sc/joinActivity.dart';

abstract class ScJoinActivityDao {
  Future<String> process(ScJoinActivity item);

}
