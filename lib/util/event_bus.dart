/// 订阅者回调签名
typedef EventCallback<T> = void Function(T arg);

/// 事件总线工具类
class EventBus {
  // 私有构造函数
  EventBus._internal();

  // 保存单例
  static final EventBus _singleton = EventBus._internal();

  // 工厂构造函数
  factory EventBus() => _singleton;

  // 保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _eventMap = <String, List<EventCallback>?>{};

  // 添加订阅者
  void on(String eventName, EventCallback f) {
    _eventMap[eventName] ??= <EventCallback>[];
    _eventMap[eventName]!.add(f);
  }

  // 移除订阅者
  void off(String eventName, [EventCallback? f]) {
    final list = _eventMap[eventName];
    if (list == null) {
      return;
    }
    if (f == null) {
      _eventMap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  // 触发事件，事件触发后该事件所有订阅者会被调用
  void emit<T>(String eventName, [T? arg]) {
    final list = _eventMap[eventName];
    if (list == null) {
      return;
    }
    for (final element in list.reversed) {
      element(arg);
    }
  }
}
