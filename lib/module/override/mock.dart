import 'package:kite/module/override/entity.dart';

import 'interface.dart';

const _json = {
  "routeOverride": [
    {
      "inputRoute": "/timetable",
      "outputRoute": "/browser",
      "args": {"initialUrl": "https://www.xxx.com", "fixedTitle": "HellasoWorld", "showSharedButton": true}
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
  ],
  "routeNotice": {
    "/egg": {
      "id": 1,
      "title": "Egg维护中",
      "msg": "Egg维护中，可能无法正常使用",
    },
    "/notice": {
      "id": 2,
      "title": "公告维护中",
      "msg": "公告维护中，可能无法正常使用",
    }
  }
};

class FunctionOverrideMock implements FunctionOverrideServiceDao {
  @override
  Future<FunctionOverrideInfo> get() async {
    return FunctionOverrideInfo.fromJson(_json);
  }
}

class FunctionOverrideDisabled implements FunctionOverrideServiceDao {
  @override
  Future<FunctionOverrideInfo> get() async {
    return FunctionOverrideInfo();
  }
}
