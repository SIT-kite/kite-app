import 'package:hive/hive.dart';
import 'package:kite/dao/kite/user_event.dart';
import 'package:kite/entity/kite/user_event.dart';

class UserEventStorage implements UserEventStorageDao {
  final Box<UserEvent> box;

  const UserEventStorage(this.box);

  @override
  void append(UserEvent event) => box.add(event);

  @override
  void clear() => box.clear();

  @override
  int getEventCount() => box.length;

  @override
  List<UserEvent> getEvents() => box.values.toList();

  @override
  void appendAll(List<UserEvent> eventList) => box.addAll(eventList);
}
