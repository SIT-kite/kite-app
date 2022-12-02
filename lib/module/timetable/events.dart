import 'package:event_bus/event_bus.dart';

import 'entity/meta.dart';

EventBus eventBus = EventBus();

class DefaultTimetableChangeEvent {
  TimetableMeta? selected;

  DefaultTimetableChangeEvent({this.selected});
}
