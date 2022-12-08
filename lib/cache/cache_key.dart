/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
part of 'box.dart';

class NamedCacheKey<T> extends CacheKey<T> {
  final String name;

  NamedCacheKey(super.box, this.name);

  @override
  T? get value {
    final cache = box.get(name);
    if (cache is T?) {
      return cache;
    } else {
      clear();
      return null;
    }
  }

  @override
  set value(T? newValue) {
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

class CacheNamespace<T> {
  final Box<dynamic> box;
  final String namespace;

  CacheNamespace(this.box, this.namespace);

  CacheKey<T> make(String name) {
    return _NamespaceCacheKey(box, namespace, name);
  }
}

class CacheNamespace1<T, Arg1> {
  final Box<dynamic> box;
  final String namespace;
  final String Function(Arg1) maker;

  CacheNamespace1(this.box, this.namespace, this.maker);

  CacheKey<T> make(Arg1 arg1) {
    return _NamespaceCacheKey(box, namespace, maker(arg1));
  }
}

class CacheNamespace2<T, Arg1, Arg2> {
  final Box<dynamic> box;
  final String namespace;
  final String Function(Arg1, Arg2) maker;

  CacheNamespace2(this.box, this.namespace, this.maker);

  CacheKey<T> make(Arg1 arg1, Arg2 arg2) {
    return _NamespaceCacheKey(box, namespace, maker(arg1, arg2));
  }
}

class _NamespaceCacheKey<T> extends CacheKey<T> {
  final String namespace;
  final String name;

  _NamespaceCacheKey(
    super.box,
    this.namespace,
    this.name,
  );

  @override
  T? get value {
    final cache = box.get("$namespace/$name");
    if (cache is T?) {
      return cache;
    } else {
      clear();
      return null;
    }
  }

  @override
  set value(T? newValue) {
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
