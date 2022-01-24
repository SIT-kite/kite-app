import 'package:kite/entity/campus_card.dart';

abstract class CampusCardDao {
  /// 根据校园卡id获取身份信息
  Future<CardInfo?> getCardInfo(int cardId);
}
