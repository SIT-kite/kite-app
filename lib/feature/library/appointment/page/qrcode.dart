import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/library/appointment/init.dart';
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
      style: TextStyle(fontSize: 30),
    );
  }
}

class QrcodePage extends StatelessWidget {
  final service = LibraryAppointmentInitializer.appointmentService;
  final int applyId;
  QrcodePage({
    Key? key,
    required this.applyId,
  }) : super(key: key);

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
                  child: buildFutureQrcode(service.getApplicationCode(applyId)),
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
