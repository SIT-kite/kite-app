import 'package:hive/hive.dart';
import 'package:kite/dao/kite/user_event.dart';
import 'package:kite/entity/kite/user_event.dart';

class UserEventStorage implements UserEventStorageDao {
  final Box<dynamic> box;

  const UserEventStorage(this.box);

  @override
  String? get uuid => box.get('uuid');

  @override
  set uuid(String? uuid) => box.put('uuid', uuid);

  @override
  void append(UserEvent event) => box.add(event);

  @override
  void clear() => box.clear();

  @override
  int getEventCount() => box.length;

  @override
  List<UserEvent> getEvents() => box.values.toList() as List<UserEvent>;

  @override
  void appendAll(List<UserEvent> eventList) => box.addAll(eventList);
}
