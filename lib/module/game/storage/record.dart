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
import 'package:hive/hive.dart';

import '../dao/local.dart';
import '../entity/record.dart';

class GameStorage implements GameRecordStorageDao {
  final Box<dynamic> box;

  const GameStorage(this.box);

  @override
  void append(GameRecord newRecord) {
    final records = getAllRecords();
    for (var r in records) {
      if (r.ts == newRecord.ts) {
        return;
      }
    }
    records.add(newRecord);
    box.put('record', records);
  }

  @override
  void deleteAll() {
    box.delete('record');
  }

  @override
  List<GameRecord> getAllRecords() {
    final List? recordList = box.get('record');
    return recordList?.map((e) => e as GameRecord).toList() ?? <GameRecord>[];
  }

  @override
  GameRecord? getLastOne() {
    try {
      return getAllRecords().last;
    } catch (_) {
      return null;
    }
  }
}
