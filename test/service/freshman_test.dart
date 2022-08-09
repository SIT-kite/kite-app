import 'package:kite/feature/freshman/dao.dart';
import 'package:kite/feature/freshman/init.dart';
import 'package:kite/mock/index.dart';
import 'package:kite/setting/init.dart';

void main() async {
  await init();
  FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;
  SettingInitializer.auth
    ..freshmanAccount = '216072111'
    ..freshmanSecret = '134629';
  test('test freshman getInfo', () async {
    Log.info(await freshmanDao.getInfo());
  });
  test('test freshman update', () async {
    Log.info(await freshmanDao.getInfo());
    await freshmanDao.update(visible: false);
    Log.info(await freshmanDao.getInfo());
  });
  test('test freshman getRoommates', () async {
    final roommates = await freshmanDao.getRoommates();
    Log.info(roommates);
  });
  test('test freshman getFamiliars', () async {
    final familiars = await freshmanDao.getFamiliars();
    Log.info(familiars);
  });
  test('test freshman getClassmates', () async {
    final classmates = await freshmanDao.getClassmates();
    Log.info(classmates);
  });
  test('test freshman getAnalysis', () async {
    final analysis = await freshmanDao.getAnalysis();
    Log.info(analysis);
  });
  test('test freshman postAnalysisLog', () async {
    await freshmanDao.postAnalysisLog();
  });
}
