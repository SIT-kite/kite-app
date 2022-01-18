import 'package:kite/entity/auth_item.dart';

abstract class AuthPoolDao {
  void add(AuthItem auth);

  AuthItem? get(String username);

  void delete(String username);

  void deleteAll();

  List<AuthItem> get all;
}
