import 'package:kite/entity/campus_card.dart';

abstract class CampusCardDao {
  Future<CardInfo?> getCardInfo(int cardId);
}
