import 'entity.dart';

abstract class FreshmanDao {
  Future<FreshmanInfo> getInfo(String account, String secret);
}
