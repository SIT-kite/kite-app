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
import 'package:app_settings/app_settings.dart';
import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kite/setting/init.dart';
import 'package:kite/util/network.dart';
import 'package:kite/util/url_launcher.dart';

import '../init.dart';
import '../service/network.dart';

class ConnectivityPage extends StatefulWidget {
  const ConnectivityPage({Key? key}) : super(key: key);

  @override
  _ConnectivityPageState createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();

    ConnectivityInitializer.ssoSession.checkConnectivity().then((value) {
      setState(() {
        isConnected = value;
      });
    });
  }

  Widget buildFigure(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color color = isConnected ? primaryColor : Colors.grey;
    return SvgPicture.asset('assets/connectivity/not-available.svg', width: 260, height: 260, color: color);
  }

  Widget buildConnectedBlock() {
    final style = Theme.of(context).textTheme.bodyText1;

    Widget buildConnectedByProxy() => Text(
        '已通过 HTTP 代理连接校园网\n'
        '地址：${SettingInitializer.network.proxy}',
        textAlign: TextAlign.center,
        style: style);

    Widget buildConnectedByVpnBlock() => Text('已通过 VPN 连接校园网', textAlign: TextAlign.center, style: style);
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
            children: [
              Text('目前已通过 WLAN 登录', style: style),
              const SizedBox(height: 10),
              Text('登录用户: $studentId\n登录地址: $ip'),
            ],
          );
        },
      );
    }

    if (SettingInitializer.network.useProxy) {
      return buildConnectedByProxy();
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

  Widget buildErrorText() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '无法连接到校园网环境，您可以: \n'
        '1. 连接学校内的 i-SIT, i-SIT-1x 或 eduroam 热点；\n'
        '2. 打开 EasyConnect App 连接学校 VPN；\n'
        '3. 自建代理服务器连接HTTP代理。\n'
        '\n'
        '如果您确信您的网络环境正常，可能因为学校服务器停机维护或崩溃，此时您可以尝试：\n'
        '1. 睡一觉；\n'
        '2. 通过小风筝内置的 “小游戏” 娱乐片刻；\n'
        '3. 放弃。',
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Widget buildDisconnectedBlock() {
    return Column(
      children: [
        buildErrorText(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
              child: ElevatedButton(
                child: Text('打开 WLAN 设置'),
                onPressed: AppSettings.openWIFISettings,
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                child: const Text('打开 EasyConnect'),
                onPressed: () => launchInBrowser('sangfor://easyconnect'),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () => launchInBrowser('https://www.sit.edu.cn/xxfw/list.htm'),
          child: const Text('点此下载 EasyConnect'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('网络工具')),
      body: Center(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(flex: 3, child: buildFigure(context)),
              // const Spacer(flex: 1),
              Expanded(flex: 3, child: isConnected ? buildConnectedBlock() : buildDisconnectedBlock()),
            ],
          ),
        ),
      ),
    );
  }
}
