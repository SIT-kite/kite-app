/// 订阅者回调签名
typedef EventCallback<T> = void Function(T? arg);

/// 事件总线工具类
/// E为事件类型，一般使用枚举类型，也可使用其他类型
class EventBus<E> {
  // 保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _eventMap = <E, List<EventCallback>?>{};

  // 添加订阅者
  void on<T>(E eventName, EventCallback<T> callback) {
    _eventMap[eventName] ??= <EventCallback>[];
    final list = _eventMap[eventName]!;
    list.add((arg) => callback(arg));
  }

  // 移除订阅者
  void off(E eventName, [EventCallback? f]) {
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

  /// 触发事件，事件触发后该事件所有订阅者会被调用
  /// T为发布参数类型
  void emit<T>(E eventName, [T? arg]) {
    final list = _eventMap[eventName];
    if (list == null) {
      return;
    }
    for (final element in list.reversed) {
      element(arg);
    }
  }
}
