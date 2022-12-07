import 'package:hive/hive.dart';
import 'package:kite/module/activity/using.dart';

abstract class HasBox<T> {
  Box<T> get box;
}

const _lastUpdateKey = ".LAST_UPDATE";

mixin CachedBox implements HasBox<dynamic> {
  // ignore: non_constant_identifier_names
  CacheKey<T> Named<T>(String name) {
    return NamedCacheKey(box, name);
  }

  // ignore: non_constant_identifier_names
  CacheNamespace<T> Namespace<T>(String namespace) {
    return CacheNamespace(box, namespace);
  }

  // ignore: non_constant_identifier_names
  CacheMap<T, K, V> AsMap<T extends Map<K, V>?, K, V>(String name) {
    return CacheMap(box, name);
  }
}

abstract class CacheKey<T> {
  final Box<dynamic> box;

  CacheKey(this.box);

  T get value;

  set value(T newValue);

  DateTime? get lastUpdate;

  set lastUpdate(DateTime? newValue);

  bool needRefresh({required Duration after});
}

class CacheMap<T extends Map<K, V>?, K, V> {
  final Box<dynamic> box;
  final String name;

  CacheMap(this.box, this.name);

  CacheKey<T?> make(K key) {
    return _MapKeyCacheKey(box, key, name);
  }
}

class _MapKeyCacheKey<T extends Map<K, V>?, K, V> extends CacheKey<T?> {
  final String nameInBox;
  final K keyInMap;

  _MapKeyCacheKey(super.box, this.keyInMap, this.nameInBox);

  @override
  T? get value => box.get(keyInMap);

  @override
  set value(T? newValue) {
    box.put(nameInBox, newValue);
    box.put("$nameInBox/$_lastUpdateKey", DateTime.now());
  }

  @override
  DateTime? get lastUpdate {
    return box.get("$nameInBox/$_lastUpdateKey");
  }

  @override
  set lastUpdate(DateTime? newValue) {
    box.put("$nameInBox/$_lastUpdateKey", DateTime.now());
  }

  @override
  bool needRefresh({required Duration after}) {
    final map = value;
    if (map == null) {
      return true;
    } else {
      return !map.containsKey(keyInMap);
    }
  }
}

class NamedCacheKey<T> extends CacheKey<T> {
  final String name;

  NamedCacheKey(super.box, this.name);

  @override
  T get value => box.get(name);

  @override
  set value(T newValue) {
    box.put(name, newValue);
    box.put("$name/$_lastUpdateKey", DateTime.now());
  }

  @override
  DateTime? get lastUpdate {
    return box.get("$name/$_lastUpdateKey");
  }

  @override
  set lastUpdate(DateTime? newValue) {
    box.put("$name/$_lastUpdateKey", DateTime.now());
  }

  @override
  bool needRefresh({required Duration after}) {
    final last = lastUpdate;
    if (last == null) {
      return true;
    } else {
      return DateTime.now().difference(last) > after;
    }
  }
}

class CacheNamespace<T> {
  final Box<dynamic> box;
  final String namespace;

  CacheNamespace(this.box, this.namespace);

  CacheKey<T> make(String name) {
    return _NamespaceSubCacheKey(box, namespace, name);
  }
}

class _NamespaceSubCacheKey<T> extends CacheKey<T> {
  final String namespace;
  final String name;

  _NamespaceSubCacheKey(
    super.box,
    this.namespace,
    this.name,
  );

  @override
  T get value => box.get("$namespace/$name");

  @override
  set value(T newValue) {
    box.put("$namespace/$name", newValue);
    lastUpdate = DateTime.now();
  }

  @override
  DateTime? get lastUpdate {
    return box.get("$namespace/$_lastUpdateKey");
  }

  @override
  set lastUpdate(DateTime? newValue) {
    box.put("$namespace/$_lastUpdateKey", DateTime.now());
  }

  @override
  bool needRefresh({required Duration after}) {
    final last = lastUpdate;
    if (last == null) {
      return true;
    } else {
      return DateTime.now().difference(last) > after;
    }
  }
}
