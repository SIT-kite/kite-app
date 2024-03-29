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
import 'package:flutter/material.dart';
import 'package:kite/module/timetable/using.dart';
import 'package:kite/override/entity.dart';

import '../entity/home.dart';
import '../user_widget/brick.dart';

Widget buildBrickWidgetByExtraHomeItem(BuildContext context, ExtraHomeItem item) {
  return Brick(
    title: item.title,
    subtitle: item.description,
    icon: SvgNetworkIcon(
      item.iconUrl,
    ),
    route: item.route,
  );
}

class HomeItemHideInfoFilter {
  // Map<functionName, Set<userType>>
  Map<String, Set<String>> map = {};

  HomeItemHideInfoFilter(List<HomeItemHideInfo> hideInfoList) {
    for (final hideInfo in hideInfoList) {
      for (final functionName in hideInfo.nameList) {
        for (final userType in hideInfo.userTypeList) {
          if (!map.containsKey(functionName)) map[functionName] = {};
          map[functionName]!.add(userType);
        }
      }
    }
  }

  // if true then should be hide
  bool willHide(FType ftype, UserType userType) {
    if (!map.containsKey(ftype.name)) return false;
    return map[ftype.name]!.contains(userType.name);
  }
}
