/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:version/version.dart';

import 'logger.dart';

const String appVersionUrl = 'https://kite.sunnysab.cn/version.txt';

class AppVersion {
  String platform;
  String version;

  AppVersion(this.platform, this.version);
}

/// 获取当前 app 版本
Future<AppVersion> getCurrentVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final platform = UniversalPlatform.isAndroid ? 'Android' : (UniversalPlatform.isIOS ? 'iOS' : 'Unknown');

  return AppVersion(platform, packageInfo.version);
}

/// Compare App version
bool needUpdate(String currentVersion, String remoteVersion) {
  Version current = Version.parse(currentVersion);
  Version remote = Version.parse(remoteVersion);

  Log.info('Current version is $currentVersion, while the remote version is $remoteVersion.');
  return current < remote;
}

/// 检查更新
Future<AppVersion?> getUpdate() async {
  if (kDebugMode) {
    return null;
  }
  // 文件格式. 苹果不支持直接下载 apk 升级.
  // android|1.0.0+12
  // ios|1.0.0+12
  final String data = (await Dio().get(appVersionUrl)).data;
  final List<String> lines = data.split('\n');
  final AppVersion current = await getCurrentVersion();

  try {
    final target = lines.firstWhere((line) => line.toLowerCase().startsWith(current.platform.toLowerCase()));
    final columns = target.split('|');

    final platform = columns[0];
    final version = columns[1];
    if (needUpdate(current.version, version)) {
      Log.info('检查到新版本 $version （当前版本 ${current.version}）');
      return AppVersion(platform, version);
    }
  } catch (_) {}

  // 如果无匹配平台, 到这里返回 null.
  Log.info('没有合适的更新.');
  return null;
}
