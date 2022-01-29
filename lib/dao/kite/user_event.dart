import 'package:kite/entity/kite/user_event.dart';

abstract class UserEventStorageDao {
  String? get uuid;

  set uuid(String? uuid);

  /// 获取本地事件总数
  int getEventCount();

  /// 获取事件列表
  List<UserEvent> getEvents();

  /// 清除本地所有事件
  void clear();

  /// 追加事件记录
  void append(UserEvent event);

  /// 追加多条事件记录
  void appendAll(List<UserEvent> eventList);
}
