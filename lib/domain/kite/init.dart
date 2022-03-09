import 'package:hive/hive.dart';
import 'package:kite/domain/kite/service/index.dart';
import 'package:kite/domain/kite/storage/electricity.dart';
import 'package:kite/util/hive_register_adapter.dart';

import 'dao/index.dart';
import 'entity/index.dart';

class KiteInitializer {
  static late ElectricityStorageDao electricityStorage;
  static late WeatherDao weatherService;

  static Future<void> init() async {
    registerAdapter(BalanceAdapter());
    registerAdapter(WeatherAdapter());
    final electricityBox = await Hive.openBox('electricity');
    electricityStorage = ElectricityStorage(electricityBox);
    weatherService = WeatherService();
  }
}
