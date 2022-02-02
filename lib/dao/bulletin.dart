import 'package:kite/entity/bulletin.dart';

abstract class BulletinDao {
  /// 获取所有的分类信息
  List<BulletinCatalogue> getAllCatalogues();

  /// 获取某篇文章内容
  Future<BulletinDetail> getBulletinDetail(String bulletinCatalogueId, String uuid);

  /// 检索文章列表
  Future<BulletinListPage> queryBulletinList(int pageIndex, String bulletinCatalogueId);
}
