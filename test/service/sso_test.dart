import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/module/login/init.dart';
import 'package:kite/network/session.dart';
import 'package:kite/global/global.dart';
import 'package:kite/mock/index.dart';

void main() async {
  await init();
  await login();
  var session = Global.ssoSession;
  test('test login', () async {
    final index = await session.request('https://myportal.sit.edu.cn/', ReqMethod.get);
    final list = BeautifulSoup(index.data)
        .find('div', class_: 'composer')!
        .findAll('li')
        .map((e) => e.text.trim().replaceAll('\n', '').replaceAll(' ', ''))
        .toList();
    expect(list[0].contains('姓名'), true);
  });
  test('get person name', () async {
    final name = await LoginInit.authServerService.getPersonName();
    print('姓名: $name');
  });
}
