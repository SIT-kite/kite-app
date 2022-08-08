import 'dart:convert';

import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/mock/index.dart';

void main() {
  String json = '''
  {
    "name": "姓名",
    "uid": 100,
    "studentId": "学号",
    "college": "学院",
    "major": "专业",
    "campus": "奉贤校区",
    "building": "xx号楼",
    "room": 111,
    "bed": "111-01",
    "counselorName": "辅导员姓名",
    "counselorTel": "手机号或固话",
    "visible": false
  }
  ''';
  FreshmanInfo f = FreshmanInfo.fromJson(jsonDecode(json));
  test('test freshman entity', () {
    expect(f.name, '姓名');
  });
}
