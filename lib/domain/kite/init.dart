import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/domain/kite/service/classroom.dart';
import 'package:kite/domain/kite/service/index.dart';
import 'package:kite/domain/kite/storage/electricity.dart';
import 'package:kite/util/hive_register_adapter.dart';

import 'dao/index.dart';
import 'entity/index.dart';

class KiteInitializer {
  static late ElectricityStorageDao electricityStorage;
  static late WeatherDao weatherService;

  static late ClassroomRemoteDao classroomService;
  static late ElectricityServiceDao electricityService;
  static late NoticeServiceDao noticeService;

  static late ASession kiteSession;
  static Future<void> init({
    required Dio dio,
    required ASession kiteSession,
  }) async {
    KiteInitializer.kiteSession = kiteSession;
    classroomService = ClassroomService(kiteSession);
    electricityService = ElectricityService(kiteSession);
    noticeService = NoticeService(kiteSession);

    registerAdapter(BalanceAdapter());
    registerAdapter(WeatherAdapter());
    final electricityBox = await Hive.openBox('electricity');
    electricityStorage = ElectricityStorage(electricityBox);
    weatherService = WeatherService();
  }
}
