import 'dart:convert';

import 'package:crypto/crypto.dart';

String sign(String ts) {
  final content = Utf8Encoder().convert('unifri.com' + ts);
  return md5.convert(content).toString();
}
