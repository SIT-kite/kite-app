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
import 'package:flutter_svg/svg.dart';
import 'package:kite/service/network.dart';
import 'package:kite/util/network.dart';

class ConnectivityPage extends StatefulWidget {
  const ConnectivityPage({Key? key}) : super(key: key);

  @override
  _ConnectivityPageState createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  final Widget disconnectedPicture =
      SvgPicture.asset('assets/connectivity/not-available.svg', width: 260, height: 260, color: Colors.grey);
  final Widget connectedPicture =
      SvgPicture.asset('assets/connectivity/not-available.svg', width: 260, height: 260, color: Colors.green[600]);

  bool isConnected = false;

  @override
  void initState() {
    super.initState();

    checkConnectivity().then((value) {
      setState(() {
        isConnected = value;
      });
    });
  }

  Widget buildFigure() => isConnected ? connectedPicture : disconnectedPicture;

  Widget buildConnectedBlock() {
    Widget buildConnectedByVpnBlock() => Text(
          '目前已通过 VPN 连接校园网',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        );
    Widget buildConnectedByWlanBlock() {
      return FutureBuilder(
        future: Network.checkStatus(),
        builder: (context, snapshot) {
          String ip = '获取中…';
          String studentId = '获取中…';
          if (snapshot.connectionState == ConnectionState.done) {
            final info = snapshot.data! as CheckStatusResult;
            ip = info.ip;
            studentId = info.uid ?? '未登录';
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('目前已通过 WLAN 登录', style: Theme.of(context).textTheme.bodyText1),
              const SizedBox(height: 10),
              Text('登录用户: $studentId\n登录地址: $ip'),
            ],
          );
        },
      );
    }

    return FutureBuilder(
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
    );
  }

  Widget buildDisconnectedBlock() {
    Widget buildErrorText() {
      return Text(
          '无法连接到校园网。\n'
          '请连接学校内的 i-SIT, i-SIT-1x 或 eduroam 热点，\n'
          '或打开 EasyConnect App 连接学校 VPN。',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1);
    }

    return SizedBox(
      height: 50,
      child: Column(
        children: [
          buildErrorText(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  child: const Text('打开 WLAN 设置'),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  child: const Text('打开 EasyConnect'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('网络工具')),
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 4),
            Expanded(flex: 3, child: buildFigure()),
            const Spacer(flex: 1),
            Expanded(flex: 3, child: isConnected ? buildConnectedBlock() : buildDisconnectedBlock()),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
