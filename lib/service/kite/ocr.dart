import 'package:dio/dio.dart';

class OcrRecognizeException implements Exception {
  final int code;
  final String msg;

  const OcrRecognizeException(this.code, this.msg);
}

class OcrServer {
  static const _ocrServerUrl = 'https://kite.sunnysab.cn/api/ocr/captcha';

  static recognize(String imageBase64) async {
    var response = await Dio().post(_ocrServerUrl, data: imageBase64);
    var result = response.data;
    var code = result['code'];
    if (result['code'] == 0) {
      return result['data'];
    }
    throw OcrRecognizeException(code, result['msg']);
  }
}
