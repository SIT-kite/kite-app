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
