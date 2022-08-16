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

import 'package:kite/util/rule.dart';

// 返回执行结果，如果false表示失败
typedef OnLaunchCallback = Future<bool> Function(String);

class LaunchScheme {
  final Rule<String> launchRule;
  final OnLaunchCallback onLaunch;

  const LaunchScheme({
    required this.launchRule,
    required this.onLaunch,
  });
}

class SchemeLauncher {
  List<LaunchScheme> schemes;
  OnLaunchCallback? onNotFound;

  SchemeLauncher({
    this.schemes = const [],
    this.onNotFound,
  });

  Future<bool> launch(String schemeText) async {
    for (final scheme in schemes) {
      // 如果被接受且执行成功，那么直接return掉
      if (scheme.launchRule.accept(schemeText)) {
        return await scheme.onLaunch(schemeText);
      }
    }

    if (onNotFound != null) {
      onNotFound!(schemeText);
    }
    return false;
  }
}
