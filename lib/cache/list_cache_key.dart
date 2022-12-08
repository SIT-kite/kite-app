part of 'box.dart';

class NamedListCacheKey<T> extends CacheKey<List<T>> {
  final String name;

  NamedListCacheKey(super.box, this.name);

  @override
  List<T>? get value {
    final cache = box.get(name);
    if (cache is List<dynamic>) {
      return cache.cast<T>();
    } else {
      clear();
      return null;
    }
  }

  @override
  set value(List<T>? newValue) {
    if (newValue == null) {
      clear();
    } else {
      box.put(name, newValue);
      lastUpdate = DateTime.now();
    }
  }

  @override
  DateTime? get lastUpdate {
    return box.get("$name/$_lastUpdateKey");
  }

  @override
  set lastUpdate(DateTime? newValue) {
    box.put("$name/$_lastUpdateKey", newValue);
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

class ListCacheNamespace<T> {
  final Box<dynamic> box;
  final String namespace;

  ListCacheNamespace(this.box, this.namespace);

  CacheKey<List<T>> make(String name) {
    return _NamespaceListCacheKey(box, namespace, name);
  }
}

class _NamespaceListCacheKey<T> extends CacheKey<List<T>> {
  final String namespace;
  final String name;

  _NamespaceListCacheKey(
      super.box,
      this.namespace,
      this.name,
      );

  @override
  List<T>? get value {
    final cache = box.get("$namespace/$name");
    if (cache is List<dynamic>) {
      return cache.cast<T>();
    } else {
      clear();
      return null;
    }
  }

  @override
  set value(List<T>? newValue) {
    if (newValue == null) {
      clear();
    } else {
      box.put("$namespace/$name", newValue);
      lastUpdate = DateTime.now();
    }
  }

  @override
  DateTime? get lastUpdate {
    return box.get("$namespace/$name/$_lastUpdateKey");
  }

  @override
  set lastUpdate(DateTime? newValue) {
    box.put("$namespace/$name/$_lastUpdateKey", newValue);
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

