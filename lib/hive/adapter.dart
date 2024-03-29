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

import 'package:kite/credential/symbol.dart';
import 'package:kite/home/entity/home.dart';
import 'package:kite/module/symbol.dart';

import 'adapter/color.dart';
import 'adapter/size.dart';
import 'adapter/version.dart';
import 'using.dart';
import 'package:kite/entities.dart';

class HiveAdapter {
  HiveAdapter._();

  static void registerAll() {
    ~ContactDataAdapter();
    ~CourseAdapter();
    ~GameTypeAdapter();
    ~GameRecordAdapter();
    ~FTypeAdapter();
    ~BalanceAdapter();
    ~WeatherAdapter();
    ~ReportHistoryAdapter();
    ~LibrarySearchHistoryItemAdapter();
    // User Type
    ~UserEventAdapter();
    ~UserEventTypeAdapter();
    ~TimetableMetaAdapter();
    // Common Type
    ~VersionAdapter();
    ~SizeAdapter();
    ~ColorAdapter();

    // Activity
    ~ActivityDetailAdapter();
    ~ActivityAdapter();
    ~ScScoreSummaryAdapter();
    ~ScActivityApplicationAdapter();
    ~ScScoreItemAdapter();
    ~ActivityTypeAdapter();
    // Exam Arrangement
    ~ExamEntryAdapter();
    // OA Announcement
    ~AnnounceDetailAdapter();
    ~AnnounceCatalogueAdapter();
    ~AnnounceRecordAdapter();
    ~AnnounceAttachmentAdapter();
    ~AnnounceListPageAdapter();
    // Application
    ~ApplicationDetailSectionAdapter();
    ~ApplicationDetailAdapter();
    ~ApplicationMetaAdapter();
    ~ApplicationMsgCountAdapter();
    ~ApplicationMsgAdapter();
    ~ApplicationMsgPageAdapter();
    ~ApplicationMessageTypeAdapter();

    // Credential
    ~OACredentialAdapter();
    ~FreshmanCredentialAdapter();
    ~UserTypeAdapter();

    // Exam Result
    ~ExamResultAdapter();
    ~ExamResultDetailAdapter();

    ~SchoolYearAdapter();
    ~SemesterAdapter();
  }
}

extension _TypeAdapterEx<T> on TypeAdapter<T> {
  void operator ~() {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(this);
    }
  }
}
