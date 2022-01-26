import 'package:hive/hive.dart';
import 'package:kite/dao/kite/jwt.dart';
import 'package:kite/storage/constants.dart';

class JwtStorage implements JwtDao {
  final Box<dynamic> box;

  JwtStorage(this.box);

  @override
  String? get jwtToken => box.get(JwtKeys.jwt, defaultValue: null);

  @override
  set jwtToken(String? jwt) => box.put(JwtKeys.jwt, jwt);
}
