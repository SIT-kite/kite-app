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

import 'dart:async';
import 'dart:convert';

import 'package:device_display_brightness/device_display_brightness.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/module/library/appointment/entity.dart';
import 'package:kite/module/library/appointment/init.dart';
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
    final df = DateFormat('yyyy-MM-dd   HH:mm:ss');
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
  final codeNotifier = ValueNotifier<ApplicationRecord?>(null);
  String codeString = '';

  double? brightness;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      brightness = await DeviceDisplayBrightness.getBrightness();
      Log.info('获取屏幕亮度: $brightness');
      Log.info('当前系统亮度: $brightness');
      DeviceDisplayBrightness.setBrightness(1);
      DeviceDisplayBrightness.keepOn(enabled: true);
    });
    service.getApplicationCode(widget.applyId).then((value) {
      codeNotifier.value = ApplicationRecord.fromJson(jsonDecode(value)['application']);
      codeString = value;
    });
    super.initState();
  }

  @override
  void dispose() {
    if (brightness != null) {
      Log.info('还原屏幕亮度: $brightness');
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

  Widget buildFutureQrcode() {
    return ValueListenableBuilder<ApplicationRecord?>(
      valueListenable: codeNotifier,
      builder: (context, data, child) {
        if (data == null) return const CircularProgressIndicator();
        return Column(
          children: [
            buildQrcode(codeString),
            Text(
              '座位号: ${data.index}\n'
              '学号: ${data.user}',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        );
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
                  child: buildFutureQrcode(),
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
