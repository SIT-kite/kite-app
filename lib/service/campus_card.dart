/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
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
