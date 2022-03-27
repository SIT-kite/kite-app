import 'dart:async';

import 'package:device_display_brightness/device_display_brightness.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/library/appointment/init.dart';
import 'package:kite/util/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TimeDisplay extends StatefulWidget {
  const TimeDisplay({Key? key}) : super(key: key);

  @override
  State<TimeDisplay> createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay> {
  DateTime currentTime = DateTime.now();
  late Timer timer;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd   HH:MM:ss');
    return Text(
      df.format(currentTime),
      style: const TextStyle(fontSize: 30),
    );
  }
}

class QrcodePage extends StatefulWidget {
  final int applyId;
  const QrcodePage({
    Key? key,
    required this.applyId,
  }) : super(key: key);

  @override
  State<QrcodePage> createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {
  final service = LibraryAppointmentInitializer.appointmentService;
  double? brightness;
  @override
  void initState() {
    print('设置屏幕');
    Future.delayed(Duration.zero, () async {
      brightness = await DeviceDisplayBrightness.getBrightness();
      Log.info('当前系统亮度: $brightness');
      DeviceDisplayBrightness.setBrightness(1);
      DeviceDisplayBrightness.keepOn(enabled: true);
    });
    super.initState();
  }

  @override
  void dispose() {
    if (brightness != null) {
      DeviceDisplayBrightness.setBrightness(brightness!);
    }
    DeviceDisplayBrightness.keepOn(enabled: false);

    super.dispose();
  }

  Widget buildQrcode(String data) {
    return Builder(builder: (context) {
      final width = MediaQuery.of(context).size.width;
      return QrImage(
        data: data,
        size: width * 0.8,
      );
    });
  }

  Widget buildFutureQrcode(Future<String> future) {
    return MyFutureBuilder<String>(
      future: future,
      builder: (context, data) {
        return buildQrcode(data);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('预约码'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                const TimeDisplay(),
                Center(
                  child: buildFutureQrcode(service.getApplicationCode(widget.applyId)),
                ),
              ],
            ),
          ),
          Text(
            '在进入图书馆时向志愿者出示本二维码',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
