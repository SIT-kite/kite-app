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
import 'package:kite/module/freshman/cache.dart';
import 'package:kite/module/freshman/dao.dart';
import 'package:kite/module/freshman/entity.dart';
import 'package:kite/module/freshman/init.dart';
import 'package:kite/module/freshman/page/component/familar_list.dart';

class FamiliarPeopleWidget extends StatefulWidget {
  const FamiliarPeopleWidget({Key? key}) : super(key: key);

  @override
  State<FamiliarPeopleWidget> createState() => _FamiliarPeopleWidgetState();
}

class _FamiliarPeopleWidgetState extends State<FamiliarPeopleWidget> {
  final FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;
  final FreshmanCacheManager freshmanCacheManager = FreshmanInitializer.freshmanCacheManager;

  void onRefresh() {
    freshmanCacheManager.clearFamiliars();
    setState(() {});
  }

  Widget buildBody(List<Familiar> familiarList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FamiliarListWidget(
            familiarList,
            onRefresh: onRefresh,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyFutureBuilder<List<Familiar>>(
      future: freshmanDao.getFamiliars(),
      builder: (context, data) {
        return buildBody(data);
      },
    );
  }
}
