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
import 'package:kite/user_widget/future_builder.dart';

import '../cache.dart';
import '../dao/Freshman.dart';
import '../entity/relationship.dart';
import '../init.dart';
import '../user_widget/mate_list.dart';

class ClassmateWidget extends StatefulWidget {
  const ClassmateWidget({Key? key}) : super(key: key);

  @override
  State<ClassmateWidget> createState() => _ClassmateWidgetState();
}

class _ClassmateWidgetState extends State<ClassmateWidget> {
  final FreshmanCacheManager freshmanCacheManager = FreshmanInitializer.freshmanCacheManager;
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;

  void onRefresh() {
    freshmanCacheManager.clearClassmates();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MyFutureBuilder<List<Mate>>(
      future: freshmanDao.getClassmates(),
      builder: (context, data) {
        return MateListWidget(
          data,
          callBack: onRefresh,
        );
      },
    );
  }
}
