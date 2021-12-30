import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:kite/main.dart' show initializeLogger;

/// 演示了日志库的基本用法
void main() {
  initializeLogger();
  var log1 = Logger('Log1');
  var log2 = Logger('Log2');

  test('should print somethings', () async {
    log1.info('Info');
    log2.warning('Warning');
  });
}
