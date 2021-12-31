import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:kite/main.dart' show initializeLogger;

/// 演示了日志库的基本用法
void main() {
  var log1 = Logger();

  test('should print somethings', () async {
    log1.i('Info');
  });
}
