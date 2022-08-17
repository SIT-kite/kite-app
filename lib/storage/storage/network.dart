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
import 'package:hive/hive.dart';
import 'package:kite/util/logger.dart';

import '../dao/network.dart';

class NetworkKeys {
  static const namespace = '/network';
  static const networkProxy = '$namespace/proxy';
  static const networkUseProxy = '$namespace/useProxy';
}

class NetworkSettingStorage implements NetworkSettingDao {
  final Box<dynamic> box;

  NetworkSettingStorage(this.box);

  @override
  String get proxy => box.get(NetworkKeys.networkProxy, defaultValue: '');

  @override
  set proxy(String foo) => box.put(NetworkKeys.networkProxy, foo);

  @override
  bool get useProxy => box.get(NetworkKeys.networkUseProxy, defaultValue: false);

  @override
  set useProxy(bool foo) {
    Log.info('使用代理：$foo');
    box.put(NetworkKeys.networkUseProxy, foo);
  }
}
