import 'package:dio/dio.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/sso/sso.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('expense test', () async {
    const cardUrl = 'http://card.sit.edu.cn/personalxiaofei.jsp';
    var username = '';
    var password = '';
    var session = Session();
    await session.login(username, password);
    var response = await session.get(
      cardUrl,
      responseType: ResponseType.bytes,
    );
    var codec = const GbkCodec();
    logger.i(codec.decode(response.data));
  });
}
