import 'package:event_bus/event_bus.dart';

import 'entity/meta.dart';

EventBus eventBus = EventBus();

class DefaultTimetableChangeEvent {
  String? selected;

  DefaultTimetableChangeEvent({this.selected});
}
