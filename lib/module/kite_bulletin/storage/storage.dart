import 'package:hive/hive.dart';
import 'package:kite/module/kite_bulletin/dao/local.dart';
import 'package:kite/module/kite_bulletin/entity/bulletin.dart';
import 'package:kite/util/json_storage.dart';

class _Key {
  static const _namespace = '/bulletin';
  static const data = '$_namespace/data';
  static const meta = '$_namespace/meta';
}

class KiteBulletinStorage implements KiteBulletinStorageDao {
  final JsonStorage jsonStorage;
  KiteBulletinStorage(Box box) : jsonStorage = JsonStorage(box);

  @override
  List<KiteBulletin> get data => jsonStorage.getModelList(_Key.data, KiteBulletin.fromJson) ?? [];
  @override
  set data(List<KiteBulletin> v) => jsonStorage.setModelList(_Key.data, v, (e) => e.toJson());

  @override
  KiteBulletinMeta? get meta => jsonStorage.getModel(_Key.meta, KiteBulletinMeta.fromJson);

  @override
  set meta(KiteBulletinMeta? meta) => jsonStorage.setModel(_Key.meta, meta, (e) => e.toJson());
}
