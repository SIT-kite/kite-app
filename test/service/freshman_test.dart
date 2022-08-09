import 'package:kite/feature/freshman/dao.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/feature/freshman/init.dart';
import 'package:kite/mock/index.dart';
import 'package:kite/setting/init.dart';

void main() async {
  await init();
  FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;
  SettingInitializer.auth
    ..freshmanAccount = '216072111'
    ..freshmanSecret = '134629';
  test('test freshman service', () async {
    FreshmanInfo info = await freshmanDao.getInfo();
    Log.info(info.name);
  });
}
