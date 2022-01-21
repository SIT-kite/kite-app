import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'campus_card.g.dart';

const String cardService = 'http://210.35.98.178:7101/LMWeb/WebApi/HYongHu.ashx';

@JsonSerializable()
class CardInfo {
  @JsonKey(name: 'DengLuMing')
  final String studentId;
  @JsonKey(name: 'ZhenShiXingMing')
  final String studentName;
  @JsonKey(name: 'ZuZhiJiGouName')
  final String major;

  const CardInfo(this.studentId, this.studentName, this.major);

  factory CardInfo.fromJson(Map<String, dynamic> json) => _$CardInfoFromJson(json);
  // Map<String, dynamic> toJson() => _$CardInfoToJson(this);`
}

String cardId2String(int cardId) {
  StringBuffer buffer = StringBuffer();

  r(int n) => n.toRadixString(16);

  buffer.write(r((cardId >> 24) & 0xFF));
  buffer.write(r((cardId >> 16) & 0xFF));
  buffer.write(r((cardId >> 8) & 0xFF));
  buffer.write(r(cardId & 0xFF));
  return buffer.toString();
}

Future<CardInfo?> getCardInfo(int cardId) async {
  var dio = Dio();
  final cardIdString = cardId2String(cardId);

  final response = await dio.get(cardService,
      queryParameters: {'KaHao': cardIdString, 'Method': 'GetUserInfoByKaHao'},
      options: Options(sendTimeout: 5, receiveTimeout: 5));
  String html = response.data;

  if (html == 'NotData') {
    return null;
  }
  return CardInfo.fromJson(jsonDecode(html));
}
