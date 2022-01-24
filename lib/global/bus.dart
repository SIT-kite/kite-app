import 'package:kite/util/event_bus.dart';

final eventBus = EventBus<EventNameConstants>();

enum EventNameConstants {
  onWeatherUpdate,
  onHomeRefresh,
  onSelectCourse,
  onRemoveCourse,
}
