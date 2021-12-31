import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/sso/sso.dart';
import 'package:logging/logging.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/main.dart' show initializeLogger;

void main() {
  initializeLogger();
  var logger = Logger('SsoTest');
  test('test login', () async {
    logger.info('login test start');
    var session = Session();
    var a = await session.login('', '');
    logger.info(a);
    var index = await session.get('https://myportal.sit.edu.cn/');
    var list = BeautifulSoup(index.data)
        .find('div', class_: 'composer')!
        .findAll('li')
        .map((e) => e.text.trim().replaceAll('\n', '').replaceAll(' ', ''))
        .toList();
    logger.info(list);
    expect(list[0].contains('姓名'), true);
  });
}
