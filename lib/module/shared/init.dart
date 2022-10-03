import 'dao/weather.dart';
import 'networking.dart';
import 'service/weather.dart';

class SharedInitializer {
  static late WeatherDao weatherService;
  static late KiteSession kiteSession;

  static Future<void> init({
    required KiteSession kiteSession,
  }) async {
    SharedInitializer.kiteSession = kiteSession;
    weatherService = WeatherService();
  }
}
