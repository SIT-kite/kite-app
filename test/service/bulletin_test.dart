import 'package:flutter_test/flutter_test.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/bulletin.dart';
import 'package:kite/util/logger.dart';

import 'mock.dart';

void main() async {
  await init();
  await login();

  final session = SessionPool.ssoSession;
  final dao = BulletinService(session);
  test('test bulletin', () async {
    final list = await dao.getAllCatalogues();
    Log.info(list);
    final bulletin = await dao.getBulletinDetail('pe2362', '7d227947-6dfc-11ec-9e2f-abfe89c3f6e3');
    Log.info(bulletin);
  });

  test('test get list', () async {
    final list = await dao.getAllCatalogues();
    final firstPage = await dao.queryBulletinList(1, list[0].id);
    Log.info(firstPage);
  });
}
