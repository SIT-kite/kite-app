import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_platform/universal_platform.dart';

const String appVersionUrl = 'https://kite.sunnysab.cn/version.txt';

class AppVersion {
  String platform;
  String version;
  String? url;

  AppVersion(this.platform, this.version, {this.url});
}

/// 获取当前 app 版本
Future<AppVersion> getCurrentVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final platform = UniversalPlatform.isAndroid ? 'Android' : (UniversalPlatform.isIOS ? 'iOS' : 'Unknown');

  return AppVersion(platform, '${packageInfo.version}+${packageInfo.buildNumber}');
}

/// 检查更新
Future<AppVersion?> getUpdate() async {
  if (kDebugMode) {
    return null;
  }
  // 文件格式. 苹果不支持直接下载 apk 升级.
  // android|1.0.0+12|https://xxx\n
  // ios|1.0.0+12|
  final String data = (await Dio().get(appVersionUrl)).data;
  final List<String> lines = data.split('\n');
  final AppVersion current = await getCurrentVersion();

  try {
    final target = lines.firstWhere((line) => line.startsWith(current.platform));
    final columns = target.split('|');

    return AppVersion(columns[0], columns[1], url: (columns[2].isEmpty ? null : columns[2]));
  } catch (_) {}

  // 如果无匹配平台, 到这里返回 null.
}
