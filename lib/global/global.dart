import 'package:kite/util/event_bus.dart';
import 'package:kite/util/page_logger.dart';

enum EventNameConstants {
  onWeatherUpdate,
  onHomeRefresh,
  onHomeItemReorder,
  onSelectCourse,
  onRemoveCourse,
  onCampusChange,
  onBackgroundChange,
  onJumpTodayTimetable,
}

/// 应用程序全局数据对象
class Global {
  static late PageLogger pageLogger;
  static final eventBus = EventBus<EventNameConstants>();
}
