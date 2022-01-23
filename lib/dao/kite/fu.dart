import 'dart:typed_data';

abstract class FuDao {
  /// 上传照片
  upload(Uint8List imageBuffer);

  /// 获取福卡列表
  getList();

  /// 查询中奖结果
  getResult();
}
