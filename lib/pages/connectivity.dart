import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConnectivityPage extends StatefulWidget {
  ConnectivityPage({Key? key}) : super(key: key);

  @override
  _ConnectivityPageState createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  final TextStyle textStyle = const TextStyle().copyWith(fontSize: 20);

  final Widget connectivityPicture = SvgPicture.asset(
      'assets/connectivity/not-available.svg',
      width: 260,
      height: 260,
      color: Colors.grey);

  Widget buildErrorText() {
    return Text(
      '无法连接到校园网。\n请连接 i-SIT, i-SIT-1x, eduroam 中的任意一个热点\n或打开 EasyConnect App 以连接 VPN。',
      textAlign: TextAlign.center,
      style: textStyle.copyWith(fontSize: 15),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            connectivityPicture,
            const SizedBox(height: 60.0),
            buildErrorText(),
            const SizedBox(height: 10.0),
            buildButtons(),
          ],
        ),
      ),
    );
  }
}
