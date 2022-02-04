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
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// 日志工具类
class Log {
  static final dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

  static String _getCaller(int deep) {
    return StackTrace.current.toString().split('\n')[deep].substring(2).split(' (')[0].trim();
  }

  static void _log(String type, dynamic message) {
    if (kDebugMode) {
      print('${getCurrentTime()}\t$type\t${_getCaller(3)}  ${message.toString()}');
    }
  }

  static String getCurrentTime() {
    final time = DateTime.now();
    return dateFormat.format(time);
  }

  static void info(dynamic m) {
    _log('INFO', m);
  }

  static void debug(dynamic m) {
    _log('DEBUG', m);
  }
}
