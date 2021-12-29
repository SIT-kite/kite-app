import 'package:flutter_appcenter_bundle/flutter_appcenter_bundle.dart';
import 'package:flutter/material.dart';

import 'package:kite/main.dart';

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

  runApp(const KiteApp());
}
