import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/sso/sso.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('edu test', () async {
    var username = '';
    var password = '';
    var session = Session();
    await session.login(username, password);
    // 先跳转到教务首页
    await session.get('http://jwxt.sit.edu.cn/sso/jziotlogin');
    // 然后成绩查询
    var scoreQueryUrl = 'http://jwxt.sit.edu.cn/jwglxt/cjcx/cjcx_cxXsgrcj.html';
    var result = await session.post(
      scoreQueryUrl,
      queryParameters: {
        'doType': 'query',
        'gnmkdm': 'N305005',
        'su': username,
      },
      data: {
        'xnm': 2021,
        'xqm': 3,
        '_search': false,
        'nd': 1641027685201,
        'queryModel.showCount': 15,
        'queryModel.currentPage': 1,
        'queryModel.sortName': '',
        'queryModel.sortOrder': 'asc',
        'time': 0,
      },
    );
    logger.i(jsonDecode(result.toString()));
  });
}
