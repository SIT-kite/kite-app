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
import 'package:flutter_svg/svg.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/route.dart';
import 'package:rettulf/rettulf.dart';

class NotFoundPage extends StatelessWidget {
  final String routeName;

  const NotFoundPage(this.routeName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.notFound404.text(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            i18n.notFound404.text(),
            Text(routeName),
            SvgPicture.asset(
              'assets/common/not-found.svg',
              width: 260,
              height: 260,
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed(RouteTable.feedback),
              child: i18n.feedbackBtn.text(),
            ),
          ],
        ),
      ),
    );
  }
}
