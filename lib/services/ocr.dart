import 'dart:convert';

import 'package:dio/dio.dart';

class OcrRecognizeException implements Exception {
  final int code;
  final String msg;
  const OcrRecognizeException(this.code, this.msg);

  @override
  String toString() {
    return "{code: $code, msg: $msg}";
  }
}

class OcrServer {
  final String hostname;
  const OcrServer(this.hostname);

  recognize(String imageBase64) async {
    var response =
        await Dio().post(hostname + '/captcha/recognition', data: imageBase64);
    var responseBody = response.data.toString();
    var result = jsonDecode(responseBody);
    var code = result['code'];
    var msg = result['msg'];
    var data = result['data'];
    if (result['code'] == 0) {
      return data['captcha'].toString();
    }
    throw OcrRecognizeException(code, msg);
  }
}
