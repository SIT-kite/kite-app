import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/global/global.dart';

import 'mock_util.dart';

void main() async {
  await init();
  await login();
  var session = Global.ssoSession;
  test('test login', () async {
    var index = await session.get('https://myportal.sit.edu.cn/');
    var list = BeautifulSoup(index.data)
        .find('div', class_: 'composer')!
        .findAll('li')
        .map((e) => e.text.trim().replaceAll('\n', '').replaceAll(' ', ''))
        .toList();
    expect(list[0].contains('姓名'), true);
  });
}
