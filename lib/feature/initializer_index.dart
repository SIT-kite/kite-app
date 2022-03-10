import 'package:kite/util/hive_register_adapter.dart';

import 'contact/entity/contact.dart';
import 'edu/entity/timetable.dart';
import 'expense/entity/expense.dart';
import 'game/entity/game.dart';
import 'home/entity/home.dart';
import 'kite/entity/electricity.dart';
import 'kite/entity/weather.dart';
import 'library/entity/search_history.dart';
import 'user_event/entity.dart';

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
export 'mail/init.dart';
export 'office/init.dart';
export 'report/init.dart';
export 'sc/init.dart';
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
  registerAdapter(LibrarySearchHistoryItemAdapter());
  registerAdapter(UserEventAdapter());
  registerAdapter(UserEventTypeAdapter());
}
