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

import 'package:kite/util/hive_register_adapter.dart';

import 'contact/entity/contact.dart';
import 'edu/timetable/entity.dart';
import 'expense/entity/expense.dart';
import 'game/entity.dart';
import 'home/entity/home.dart';
import 'kite/entity/electricity.dart';
import 'kite/entity/weather.dart';
import 'library/search/entity/search_history.dart';
import 'report/entity/report.dart';
import 'user_event/entity.dart';

export 'activity/init.dart';
export 'bulletin/init.dart';
export 'campus_card/init.dart';
export 'connectivity/init.dart';
export 'contact/init.dart';
export 'edu/init.dart';
export 'expense/init.dart';
export 'game/init.dart';
export 'home/init.dart';
export 'kite/init.dart';
export 'library/init.dart';
export 'login/init.dart';
export 'mail/init.dart';
export 'office/init.dart';
export 'report/init.dart';
export 'user_event/init.dart';

void registerAdapters() {
  registerAdapter(ContactDataAdapter());
  registerAdapter(CourseAdapter());
  registerAdapter(ExpenseRecordAdapter());
  registerAdapter(ExpenseTypeAdapter());
  registerAdapter(GameTypeAdapter());
  registerAdapter(GameRecordAdapter());
  registerAdapter(FunctionTypeAdapter());
  registerAdapter(BalanceAdapter());
  registerAdapter(WeatherAdapter());
  registerAdapter(ReportHistoryAdapter());
  registerAdapter(LibrarySearchHistoryItemAdapter());
  registerAdapter(UserEventAdapter());
  registerAdapter(UserEventTypeAdapter());
  registerAdapter(TimetableMetaAdapter());
}
