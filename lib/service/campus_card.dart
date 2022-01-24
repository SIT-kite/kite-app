import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kite/dao/campus_card.dart';
import 'package:kite/entity/campus_card.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

const String _cardService = 'http://210.35.98.178:7101/LMWeb/WebApi/HYongHu.ashx';

class CampusCardService extends AService implements CampusCardDao {
  CampusCardService(ASession session) : super(session);

  /// 卡id转字符串
  String _cardId2String(int cardId) {
    StringBuffer buffer = StringBuffer();

    r(int n) => n.toRadixString(16);

    buffer.write(r((cardId >> 24) & 0xFF));
    buffer.write(r((cardId >> 16) & 0xFF));
    buffer.write(r((cardId >> 8) & 0xFF));
    buffer.write(r(cardId & 0xFF));
    return buffer.toString();
  }

  @override
  Future<CardInfo?> getCardInfo(int cardId) async {
    var dio = Dio();
    final cardIdString = _cardId2String(cardId);

    final response = await dio.get(_cardService,
        queryParameters: {'KaHao': cardIdString, 'Method': 'GetUserInfoByKaHao'},
        options: Options(sendTimeout: 5, receiveTimeout: 5));
    String html = response.data;

    if (html == 'NotData') {
      return null;
    }
    return CardInfo.fromJson(jsonDecode(html));
  }
}
