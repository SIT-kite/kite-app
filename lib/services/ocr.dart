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
  static const _ocrServerUrl = 'http://10.1.160.21:5000';

  static recognize(String imageBase64) async {
    var response = await Dio().post(
      '$_ocrServerUrl/ocr/captcha',
      data: imageBase64,
    );
    var result = response.data;
    var code = result['code'];
    if (result['code'] == 0) {
      return result['data'];
    }
    throw OcrRecognizeException(code, result['msg']);
  }
}
