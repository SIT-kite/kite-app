/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../service/network.dart';
import '../using.dart';

class ConnectedBlock extends StatefulWidget {
  const ConnectedBlock({super.key});

  @override
  State<ConnectedBlock> createState() => _ConnectedBlockState();
}

class _ConnectedBlockState extends State<ConnectedBlock> {
  @override
  Widget build(BuildContext context) {
    return buildBody(context).column(maa: MainAxisAlignment.center, caa: CrossAxisAlignment.center);
  }

  List<Widget> buildBody(BuildContext context) {
    final style = context.textTheme.bodyText1;

    late Widget buildConnectedByProxy = Text(
        '${i18n.connectivityConnectedByVpn}\n'
        '${i18n.address}：${Kv.network.proxy}',
        textAlign: TextAlign.center,
        style: style);

    Widget buildConnectedByVpnBlock() =>
        Text(i18n.connectivityConnectedByVpn, textAlign: TextAlign.center, style: style);
    Widget buildConnectedByWlanBlock() {
      return FutureBuilder(
        future: Network.checkStatus(),
        builder: (context, snapshot) {
          String ip = i18n.fetching;
          String studentId = i18n.fetching;
          if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data;
            if (data is CheckStatusResult) {
              ip = data.ip;
              studentId = data.uid ?? i18n.notLoggedIn;
            } else {
              ip = i18n.unknown;
              studentId = i18n.unknown;
            }
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(i18n.connectivityConnectedByWlan, style: style),
              const SizedBox(height: 10),
              Text('${i18n.studentID}: $studentId'),
              Text('${i18n.address}: $ip'),
            ],
          );
        },
      );
    }

    if (Kv.network.useProxy) {
      return [buildConnectedByProxy];
    }
    return [
      FutureBuilder(
        future: CheckVpnConnection.isVpnActive(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final isVpnActive = snapshot.data!;
            if (false == isVpnActive) {
              return buildConnectedByWlanBlock();
            }
          }
          return buildConnectedByVpnBlock();
        },
      )
    ];
  }
}
