import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/setting/dao/freshman.dart';

import 'common.dart';

class FreshmanCacheKeys {
  static const namespace = '/freshman';
  static const basicInfo = '$namespace/cache/basicInfo';
  static const classmates = '$namespace/cache/classmates';
  static const roommates = '$namespace/cache/roommates';
  static const analysis = '$namespace/cache/analysis';
  static const familiars = '$namespace/cache/familiars';

  static const authAccount = '$namespace/auth/account';
  static const authSecret = '$namespace/auth/secret';
  static const authName = '$namespace/auth/name';
}

class FreshmanCacheStorage implements FreshmanCacheDao {
  final JsonStorage jsonStorage;
  final Box<dynamic> box;
  FreshmanCacheStorage(this.box) : jsonStorage = JsonStorage(box);

  @override
  Analysis? get analysis => jsonStorage.getModel(FreshmanCacheKeys.analysis, Analysis.fromJson);

  @override
  set analysis(Analysis? foo) => jsonStorage.setModel<Analysis>(FreshmanCacheKeys.analysis, foo, (e) => e.toJson());

  @override
  FreshmanInfo? get basicInfo => jsonStorage.getModel(FreshmanCacheKeys.basicInfo, FreshmanInfo.fromJson);

  @override
  set basicInfo(FreshmanInfo? foo) =>
      jsonStorage.setModel<FreshmanInfo>(FreshmanCacheKeys.basicInfo, foo, (e) => e.toJson());

  @override
  List<Familiar>? get familiars => jsonStorage.getModelList(FreshmanCacheKeys.familiars, Familiar.fromJson);

  @override
  set familiars(List<Familiar>? foo) =>
      jsonStorage.setModelList<Familiar>(FreshmanCacheKeys.familiars, foo, (e) => e.toJson());

  @override
  List<Mate>? get classmates => jsonStorage.getModelList(FreshmanCacheKeys.classmates, Mate.fromJson);

  @override
  set classmates(List<Mate>? foo) =>
      jsonStorage.setModelList<Mate>(FreshmanCacheKeys.classmates, foo, (e) => e.toJson());

  @override
  List<Mate>? get roommates => jsonStorage.getModelList(FreshmanCacheKeys.roommates, Mate.fromJson);

  @override
  set roommates(List<Mate>? foo) => jsonStorage.setModelList<Mate>(FreshmanCacheKeys.roommates, foo, (e) => e.toJson());

  @override
  String? get freshmanAccount => box.get(FreshmanCacheKeys.authAccount);

  @override
  set freshmanAccount(String? foo) => box.put(FreshmanCacheKeys.authAccount, foo);

  @override
  String? get freshmanSecret => box.get(FreshmanCacheKeys.authSecret);

  @override
  set freshmanSecret(String? foo) => box.put(FreshmanCacheKeys.authSecret, foo);

  @override
  String? get freshmanName => box.get(FreshmanCacheKeys.authName);

  @override
  set freshmanName(String? foo) => box.put(FreshmanCacheKeys.authName, foo);
}
