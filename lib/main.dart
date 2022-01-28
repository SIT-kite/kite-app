import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:kite/app.dart';
import 'package:kite/global/init_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 运行前初始化
  await initBeforeRun();
  runApp(Phoenix(child: const KiteApp()));
}
