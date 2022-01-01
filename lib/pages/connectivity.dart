import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';
import 'package:flutter_svg/svg.dart';

import 'package:kite/services/network.dart';

class ConnectivityPage extends StatefulWidget {
  ConnectivityPage({Key? key}) : super(key: key);

  @override
  _ConnectivityPageState createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  final TextStyle textStyle = const TextStyle().copyWith(fontSize: 20);

  final Widget disconnectedPicture = SvgPicture.asset(
      'assets/connectivity/not-available.svg',
      width: 260,
      height: 260,
      color: Colors.grey);
  final Widget connectedPicture = SvgPicture.asset(
      'assets/connectivity/not-available.svg',
      width: 260,
      height: 260,
      color: Colors.green[600]);

  bool isConnected = false;

  bool checkConnectivity() {
    /*
    There are 2 situations: Connected to LAN or WLAN to campus network directly, or connect by VPN.
    210.35.96.2 is a DNS server of inner network, which can be accessed in both situations.
    */
    final ping =
        Ping('210.35.96.2', count: 1, timeout: 2, interval: 1, ipv6: false);
    bool isSuccess = false;

    ping.stream.listen((event) {
      if (event.summary?.received != null && event.summary?.received == 1) {
        isSuccess = true;
      }
    });
    return isSuccess;
  }

  Widget getFigure() => isConnected ? connectedPicture : disconnectedPicture;

  Widget buildText() {
    Widget buildErrorText() {
      return Text(
        '无法连接到校园网。\n请连接 i-SIT, i-SIT-1x, eduroam 中的任意一个热点\n或打开 EasyConnect App 以连接 VPN。',
        textAlign: TextAlign.center,
        style: textStyle.copyWith(fontSize: 15),
      );
    }

    Widget buildConnectedByVpnText() => const Text('当前已通过 VPN 连接校园网');
    Widget buildConnectedByWlan(String ip, String studentId) =>
        Text('当前已通过 WLAN 登录\n登录地址: $ip\n登录用户: $studentId');
    return FutureBuilder<bool>(
      future: CheckVpnConnection.isVpnActive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool isVpnActive = snapshot.data!;
          if (isVpnActive) {
            return buildConnectedByVpnText();
          }
        }
        return FutureBuilder<CheckStatusResult>(
          future: Network.checkStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              CheckStatusResult result = snapshot.data!;
              if (result.result == 1) {
                return buildConnectedByWlan(result.ip, result.uid ?? '');
              }
            }
            return buildErrorText();
          },
        );
      },
    );
  }

  Widget buildButtons() {
    return SizedBox(
      height: 50,
      child: Column(children: [
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
      ]),
    );
  }

  Widget buildDisconnectedBlock() {
    return Column(
        children: [buildText(), const SizedBox(height: 10.0), buildButtons()]);
  }

  Widget buildConnectedBlock() {
    return Column(children: [
      buildText(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getFigure(),
            const SizedBox(height: 60.0),
            // isConnected ?
            buildText(),
          ],
        ),
      ),
    );
  }
}
