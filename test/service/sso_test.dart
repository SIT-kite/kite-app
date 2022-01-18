import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';

void main() async {
  await StoragePool.init();
  await SessionPool.init();
  test('test login', () async {
    var session = SessionPool.ssoSession;
    var a = await session.login('', '');
    var index = await session.get('https://myportal.sit.edu.cn/');
    var list = BeautifulSoup(index.data)
        .find('div', class_: 'composer')!
        .findAll('li')
        .map((e) => e.text.trim().replaceAll('\n', '').replaceAll(' ', ''))
        .toList();
    expect(list[0].contains('姓名'), true);
  });
}
