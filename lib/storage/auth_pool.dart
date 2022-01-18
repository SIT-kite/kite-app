import 'package:hive/hive.dart';
import 'package:kite/dao/auth_pool.dart';
import 'package:kite/entity/auth_item.dart';

class AuthPoolStorage implements AuthPoolDao {
  final Box<AuthItem> box;
  const AuthPoolStorage(this.box);

  @override
  void add(AuthItem auth) {
    box.put(auth.username, auth);
  }

  @override
  List<AuthItem> get all => box.values.toList();

  @override
  void delete(String username) {
    box.delete(username);
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys);
  }

  @override
  AuthItem? get(String username) {
    return box.get(username);
  }
}
