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
import 'adapter/version.dart';

class HiveAdapter {
  HiveAdapter._();

  static void registerAll() {
    _r(ContactDataAdapter());
    _r(CourseAdapter());
    _r(GameTypeAdapter());
    _r(GameRecordAdapter());
    _r(FTypeAdapter());
    _r(BalanceAdapter());
    _r(WeatherAdapter());
    _r(ReportHistoryAdapter());
    _r(LibrarySearchHistoryItemAdapter());
    _r(UserEventAdapter());
    _r(UserEventTypeAdapter());
    _r(ReportHistoryAdapter());
    _r(TimetableMetaAdapter());
    _r(SizeAdapter());
    _r(ColorAdapter());

    // Activity
    _r(ActivityDetailAdapter());
    _r(ActivityAdapter());
    _r(ScScoreSummaryAdapter());
    _r(ScActivityApplicationAdapter());
    _r(ScScoreItemAdapter());
    _r(ActivityTypeAdapter());
    // Exam Arrangement
    _r(ExamEntryAdapter());
    // OA Announcement
    _r(AnnounceDetailAdapter());
    _r(AnnounceCatalogueAdapter());
    _r(AnnounceRecordAdapter());
    _r(AnnounceAttachmentAdapter());
    _r(AnnounceListPageAdapter());
    // Application
    _r(ApplicationDetailSectionAdapter());
    _r(ApplicationDetailAdapter());
    _r(ApplicationMetaAdapter());
    _r(ApplicationMsgCountAdapter());
    _r(ApplicationMsgAdapter());
    _r(ApplicationMsgPageAdapter());
    _r(ApplicationMessageTypeAdapter());

    _r(VersionAdapter());
  }

  static void _r<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }
}
