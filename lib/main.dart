import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:kite/app.dart';
import 'package:logging/logging.dart';

void main() async {
  /* Initialize Microsoft AppCenter Analytics */
  // await AppCenter.startAsync(
  //   appSecretAndroid: '******',
  //   appSecretIOS: '******',
  //   enableAnalytics: true, // Defaults to true
  //   enableCrashes: true, // Defaults to true
  //   enableDistribute: false,
  //   usePrivateDistributeTrack: false, // Defaults to false
  //   disableAutomaticCheckForUpdate: true, // Defaults to false
  // );

  // AppCenter.trackEventAsync('Start', <String, String> {
  //   'prop1': 'prop1',
  //   'prop2': 'prop2',
  // });

  // Initialize logger, only in debug mode
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print(
        '${record.level.name}: ${record.loggerName}: ${record.message}',
      );
    });
  }
  runApp(const KiteApp());
}
