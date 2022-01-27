import 'dart:math';
import 'dart:typed_data';

import 'package:kite/dao/kite/fu.dart';
import 'package:kite/entity/kite/fu.dart';
import 'package:kite/util/logger.dart';

class FuMock implements FuDao {
  List<MyCard> myCards = [];
  int maxLimitCount = 2;
  int todayCount = 0;
  @override
  Future<List<MyCard>> getList() async {
    return myCards;
  }

  @override
  Future<PraiseResult> getResult() async {
    // 未开奖
    return PraiseResult()..hasResult = false;
  }

  @override
  Future<UploadResultModel> upload(Uint8List imageBuffer) async {
    if (todayCount >= maxLimitCount) {
      Log.info('达到单日最大次数限制');
      return UploadResultModel()..result = UploadResult.maxLimit;
    }
    Log.info('识别中');
    await Future.delayed(const Duration(seconds: 1));

    todayCount++;
    if (Random.secure().nextInt(2) == 0) {
      Log.info('找不到校徽');
      return UploadResultModel()..result = UploadResult.noBadge;
    }
    Log.info('识别成功');
    if (Random.secure().nextInt(2) == 0) {
      Log.info('没抽到卡片');
      return UploadResultModel()..result = UploadResult.failed;
    }
    Log.info('抽到卡片');
    final card = UploadResultModel()
      ..result = UploadResult.successful
      ..type = [
        FuType.loveCountry,
        FuType.wealthy,
        FuType.harmony,
        FuType.friendly,
        FuType.dedicateToWork
      ][Random.secure().nextInt(5)];
    // 添加到卡包
    myCards.add(MyCard()
      ..type = card.type
      ..ts = DateTime.now());
    return card;
  }
}
