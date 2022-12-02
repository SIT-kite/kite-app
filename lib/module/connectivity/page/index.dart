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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kite/design/user_widgets/dialog.dart';

import '../init.dart';
import '../service/network.dart';
import '../using.dart';

class ConnectivityPage extends StatefulWidget {
  const ConnectivityPage({Key? key}) : super(key: key);

  @override
  State<ConnectivityPage> createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  bool isConnected = false;
  late Future checkConnectivityFuture;

  @override
  void initState() {
    super.initState();

    checkConnectivityFuture = ConnectivityInit.ssoSession.checkConnectivity().then((value) {
      Log.info('当前是否连接校园网：$value');
      if (!mounted) return;
      setState(() => isConnected = value);
    });
  }

  Widget buildFigure(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color color = isConnected ? primaryColor : Colors.grey;
    return SvgPicture.asset('assets/connectivity/not-available.svg', width: 180.h, height: 180.h, color: color);
  }

  List<Widget> buildConnectedBlock() {
    final style = Theme.of(context).textTheme.bodyText1;

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

  Widget buildErrorText() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        i18n.connectivityConnectFailedError,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  List<Widget> buildDisconnectedBlock() {
    return [
      buildErrorText(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: AppSettings.openWIFISettings,
            child: i18n.openWlanSettingsBtn.txt,
          ),
          ElevatedButton(
              child: i18n.launchEasyConnectBtn.txt,
              onPressed: () async {
                final launched = await GlobalLauncher.launch('sangfor://easyconnect');
                if (!launched) {
                  if (!mounted) return;
                  final confirm = await context.showRequest(
                      title: i18n.easyconnectLaunchFailed,
                      desc: i18n.easyconnectLaunchFailedDesc,
                      yes: i18n.download,
                      no: i18n.notNow,
                      highlight: true);
                  if (confirm == true) {
                    await GlobalLauncher.launch(R.easyConnectDownloadUrl);
                  }
                }
              }),
        ],
      ),
      /* TextButton(
          onPressed: () async {
            EasyLoading.show(status: '正在登录');
            final username = Kv.auth.currentUsername;
            final password = Kv.auth.ssoPassword;
            try {
              if (username != null && password != null) await Network.login(username, password);
              if (!mounted) return;
              setState(() {});
            } on DioError catch (e) {
              if (e.type == DioErrorType.connectTimeout) {
                EasyLoading.showToast('登录请求发生异常: 连接超时');
              } else {
                EasyLoading.showToast('登录请求发生异常: ${e.message}');
              }
            } finally {
              EasyLoading.dismiss();
            }
          },
          child: const Text('一键登录i-SIT'),
        ),*/
    ];
  }

  @override
  Widget build(BuildContext context) {
    final block = isConnected ? buildConnectedBlock() : buildDisconnectedBlock();
    return Scaffold(
      appBar: AppBar(title: i18n.networkTool.txt),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildFigure(context),
            ...block,
          ],
        ),
      ),
    );
  }
}
