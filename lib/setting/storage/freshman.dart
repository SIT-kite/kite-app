import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/setting/dao/freshman.dart';

class FreshmanCacheKeys {
  static const namespace = '/freshman';
  static const basicInfo = '$namespace/basicInfo';
}

class FreshmanCacheStorage implements FreshmanCacheDao {
  final Box<dynamic> box;
  FreshmanCacheStorage(this.box);

  @override
  FreshmanInfo? get basicInfo {
    String? json = box.get(FreshmanCacheKeys.basicInfo);
    if (json == null) return null;
    return FreshmanInfo.fromJson(jsonDecode(json));
  }

  @override
  set basicInfo(FreshmanInfo? foo) {
    if (foo == null) {
      box.put(FreshmanCacheKeys.basicInfo, null);
      return;
    }
    // 不为空时
    String json = jsonEncode(foo.toJson());
    box.put(FreshmanCacheKeys.basicInfo, json);
  }
}
