import 'package:kite/feature/freshman/dao.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/feature/freshman/init.dart';
import 'package:kite/mock/index.dart';

void main() async {
  await init();
  FreshmanDao freshmanDao = FreshmanInitializer.freshmanDao;
  test('test freshman service', () async {
    FreshmanInfo info = await freshmanDao.getInfo('216072111', '134629');
    print(info.name);
  });
}
