import 'dart:convert';

import 'package:kite/feature/freshman/dao.dart';
import 'package:kite/feature/freshman/entity.dart';

class FreshmanMock implements FreshmanDao {
  @override
  Future<FreshmanInfo> getInfo() async {
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
    return f;
  }

  @override
  Future<Analysis> getAnalysis() {
    // TODO: implement getAnalysis
    throw UnimplementedError();
  }

  @override
  Future<List<Mate>> getClassmates() {
    // TODO: implement getClassmates
    throw UnimplementedError();
  }

  @override
  Future<List<Familiar>> getFamiliars() {
    // TODO: implement getFamiliars
    throw UnimplementedError();
  }

  @override
  Future<List<Mate>> getRoommates() {
    // TODO: implement getRoommates
    throw UnimplementedError();
  }

  @override
  Future<void> postAnalysisLog() {
    // TODO: implement postAnalysisLog
    throw UnimplementedError();
  }

  @override
  Future<void> update({Contact? contact, bool? visible}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Contact> getContact() {
    // TODO: implement getContact
    throw UnimplementedError();
  }
}
