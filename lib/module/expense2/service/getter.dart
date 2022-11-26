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
import 'dart:collection';
import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../dao/getter.dart';
import '../entity/local.dart';
import '../entity/remote.dart';
import '../using.dart';
import 'anaylze.dart';

class ExpenseGetService implements ExpenseGetDao {
  String al2(int v) => v < 10 ? "0$v" : "$v";

  String format(DateTime d) => "${d.year}${al2(d.month)}${al2(d.day)}${al2(d.hour)}${al2(d.minute)}${al2(d.second)}";

  static const String magicNumberX = "YWRjNGFjNjgyMmZkNDYyNzgwZjg3OGI4NmNiOTQ2ODg=";
  static const urlPath = "https://xgfy.sit.edu.cn/yktapi/services/querytransservice/querytrans";
  final ISession session;

  ExpenseGetService(this.session);

  @override
  Future<List<Transaction>> fetch({
    required String studentID,
    required DateTime from,
    required DateTime to,
  }) async {
    String curTs = format(DateTime.now());
    String fromTs = format(from);
    String toTs = format(to);
    String auth = composeAuth(studentID, fromTs, toTs, curTs);

    final res = await session.request(
      urlPath,
      ReqMethod.post,
      para: {
        'timestamp': curTs,
        'starttime': fromTs,
        'endtime': toTs,
        'sign': auth,
        'sign_method': 'HMAC',
        'stuempno': studentID,
      },
      options: SessionOptions(contentType: 'text/plain'),
    );
    final raw = anaylzeJson(res.data);
    return raw.retdata.map(analyzeFull).toList();
  }

  DatapackRaw anaylzeJson(dynamic data) {
    var res = HashMap<String, dynamic>.of(data);
    var retdataRaw = res["retdata"];
    var retdata = json.decode(retdataRaw);
    res["retdata"] = retdata;
    return DatapackRaw.fromJson(res);
  }

  String composeAuth(String studentId, String from, String to, String cur) {
    String magicNumber = utf8.decode(base64.decode(magicNumberX));
    String full = studentId + from + to + cur;
    var msg = utf8.encode(full);
    var key = utf8.encode(magicNumber);
    var hmac = Hmac(sha1, key);
    return hmac.convert(msg).toString();
  }
}
