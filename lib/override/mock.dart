/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:kite/backend.dart';

import 'entity.dart';
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
      "iconUrl": "${Backend.kite}/page/assets/assets/home/icon_exam.svg"
    }
  ],
  "homeItemHide": [
    {
      "nameList": ["electricity_bill"],
      "userTypeList": ["undergraduate", "postgraduate"]
    },
    {
      "nameList": ["switchAccount", "switchAccount"],
      "userTypeList": ["undergraduate", "postgraduate"]
    }
  ],
  "routeNotice": {
    "/easter_egg": {
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
