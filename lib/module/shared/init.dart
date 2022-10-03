import 'dao/weather.dart';
import 'networking.dart';
import 'service/weather.dart';

class SharedInit {
  static late WeatherDao weatherService;
  static late KiteSession kiteSession;

  static Future<void> init({
    required KiteSession kiteSession,
  }) async {
    SharedInit.kiteSession = kiteSession;
    weatherService = WeatherService();
  }
}
