/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:hive/hive.dart';
import 'package:kite/home/entity/home.dart';

import 'package:kite/module/symbol.dart';

import 'adapter/color.dart';
import 'adapter/size.dart';

class HiveAdapter {
  HiveAdapter._();
  static void registerAll() {
    _register(ContactDataAdapter());
    _register(CourseAdapter());
    _register(GameTypeAdapter());
    _register(GameRecordAdapter());
    _register(FTypeAdapter());
    _register(BalanceAdapter());
    _register(WeatherAdapter());
    _register(ReportHistoryAdapter());
    _register(LibrarySearchHistoryItemAdapter());
    _register(UserEventAdapter());
    _register(UserEventTypeAdapter());
    _register(ReportHistoryAdapter());
    _register(TimetableMetaAdapter());
    _register(SizeAdapter());
    _register(ColorAdapter());
    _register(ActivityDetailAdapter());
    _register(ActivityAdapter());
    _register(ScScoreSummaryAdapter());
    _register(ScActivityApplicationAdapter());
    _register(ScScoreItemAdapter());
    _register(ActivityTypeAdapter());
    _register(ExamEntryAdapter());
  }

  static void _register<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }
}
