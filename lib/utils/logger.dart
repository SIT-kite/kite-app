import 'package:logger/logger.dart';

/// 日志工具类
class Log {
  static final Logger _logger = Logger();

  static void info(dynamic m) {
    _logger.i(m);
  }

  static void debug(dynamic m) {
    _logger.d(m);
  }
}
