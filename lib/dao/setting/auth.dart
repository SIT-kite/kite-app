abstract class AuthSettingDao {
  /// 获取当前登录用户的用户名
  String? get currentUsername;

  /// 设置一个null表示退出登录当前用户
  set currentUsername(String? foo);
}
