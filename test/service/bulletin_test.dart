import 'package:kite/module/oa_announce/init.dart';
import '../init.dart';

void main() async {
  await init();
  await login();

  final dao = OaAnnounceInit.service;
  test('test oa_announcement', () async {
    final list = dao.getAllCatalogues();
    Log.info(list);
    final bulletin = await dao.getAnnounceDetail('pe2362', '7d227947-6dfc-11ec-9e2f-abfe89c3f6e3');
    Log.info(bulletin);
  });

  test('test get list', () async {
    final list = await dao.getAllCatalogues();
    final firstPage = await dao.queryAnnounceList(1, list[0].id);
    Log.info(firstPage);
  });
}
