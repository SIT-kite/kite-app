import 'dart:typed_data';

import 'package:kite/entity/kite/fu.dart';

abstract class FuDao {
  /// 上传照片
  Future<UploadResultModel> upload(Uint8List imageBuffer);

  /// 获取我的福卡列表
  Future<List<MyCard>> getList();

  /// 查询中奖结果
  Future<PraiseResult> getResult();
}
