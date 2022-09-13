import 'dart:convert';

import 'package:kite/feature/override/entity.dart';

import 'interface.dart';

const _json = """
{
  "routeOverride": [
    {
      "inputRoute": "/timetable",
      "outputRoute": "/browser",
      "args": {
        "initialUrl": "https://www.xxx.com",
        "fixedTitle": "HellasoWorld",
        "showSharedButton": true
      }
    }
  ],
  "extraHomeItem": [
    {
      "title": "func1",
      "route": "/abc",
      "description": "description1234",
      "iconUrl": "https://kite.sunnysab.cn/page/assets/assets/home/icon_exam.svg"
    }
  ],
  "homeItemHide": [
    {
      "nameList": ["electricity"],
      "userTypeList": ["undergraduate", "postgraduate"]
    },
    {
      "nameList": ["switchAccount", "switchAccount"],
      "userTypeList": ["undergraduate", "postgraduate"]
    }
  ]
}

""";

class FunctionOverrideMock implements FunctionOverrideServiceDao {
  @override
  Future<FunctionOverrideInfo> get() async {
    return FunctionOverrideInfo.fromJson(jsonDecode(_json));
  }
}
