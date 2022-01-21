abstract class NetworkSettingDao {
  // 代理服务器地址
  String get proxy;

  set proxy(String foo);

  // 是否启用代理
  bool get useProxy;

  set useProxy(bool foo);
}
