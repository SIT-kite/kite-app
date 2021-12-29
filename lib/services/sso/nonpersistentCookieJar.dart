import 'dart:io';

// ignore: implementation_imports
import 'package:cookie_jar/src/cookie_jar.dart';
// ignore: implementation_imports
import 'package:cookie_jar/src/serializable_cookie.dart';

/// A copy of [DefaultCookieJar], but with an independent cookie storage.
class NonpersistentCookieJar implements CookieJar {
  /// A array to save cookies.
  ///
  /// [domains[0]] save the cookies with "domain" attribute.
  /// These cookie usually need to be shared among multiple domains.
  ///
  /// [domains[1]] save the cookies without "domain" attribute.
  /// These cookies are private for each host name.
  ///
  final List<
          Map<
              String?, //domain or host
              Map<
                  String, //path
                  Map<
                      String, //cookie name
                      SerializableCookie //cookie
                      >>>> _cookies =
      <Map<String?, Map<String, Map<String, SerializableCookie>>>>[
    <String?, Map<String, Map<String, SerializableCookie>>>{},
    <String?, Map<String, Map<String, SerializableCookie>>>{}
  ];

  NonpersistentCookieJar({this.ignoreExpires = false});

  Map<String?, Map<String, Map<String, SerializableCookie>>>
      get domainCookies => _cookies[0];

  Map<String?, Map<String, Map<String, SerializableCookie>>> get hostCookies =>
      _cookies[1];

  @override
  Future<List<Cookie>> loadForRequest(Uri uri) async {
    final list = <Cookie>[];
    final urlPath = uri.path.isEmpty ? '/' : uri.path;
    // Load cookies without "domain" attribute, include port.
    final hostname = uri.host;
    for (final domain in hostCookies.keys) {
      if (hostname == domain) {
        final cookies =
            hostCookies[domain]!.cast<String, Map<String, dynamic>>();
        var keys = cookies.keys.toList()
          ..sort((a, b) => b.length.compareTo(a.length));
        for (final path in keys) {
          if (urlPath.toLowerCase().contains(path)) {
            final values = cookies[path]!;
            for (final key in values.keys) {
              final SerializableCookie cookie = values[key];
              if (_check(uri.scheme, cookie)) {
                if (list.indexWhere((e) => e.name == cookie.cookie.name) ==
                    -1) {
                  list.add(cookie.cookie);
                }
              }
            }
          }
        }
      }
    }
    // Load cookies with "domain" attribute, Ignore port.
    domainCookies.forEach(
        (String? domain, Map<String, Map<String, SerializableCookie>> cookies) {
      if (uri.host.contains(domain!)) {
        cookies.forEach((String path, Map<String, SerializableCookie> values) {
          if (urlPath.toLowerCase().contains(path)) {
            values.forEach((String key, SerializableCookie v) {
              if (_check(uri.scheme, v)) {
                list.add(v.cookie);
              }
            });
          }
        });
      }
    });
    return list;
  }

  @override
  Future<void> saveFromResponse(Uri uri, List<Cookie> cookies) async {
    for (final cookie in cookies) {
      var domain = cookie.domain;
      String path;
      var index = 0;
      // Save cookies with "domain" attribute
      if (domain != null) {
        if (domain.startsWith('.')) {
          domain = domain.substring(1);
        }
        path = cookie.path ?? '/';
      } else {
        index = 1;
        // Save cookies without "domain" attribute
        path = cookie.path ?? (uri.path.isEmpty ? '/' : uri.path);
        domain = uri.host;
      }
      var mapDomain =
          _cookies[index][domain] ?? <String, Map<String, dynamic>>{};
      mapDomain = mapDomain.cast<String, Map<String, dynamic>>();

      final map = mapDomain[path] ?? <String, dynamic>{};
      map[cookie.name] = SerializableCookie(cookie);
      if (_isExpired(map[cookie.name])) {
        map.remove(cookie.name);
      }
      mapDomain[path] = map.cast<String, SerializableCookie>();
      _cookies[index][domain] =
          mapDomain.cast<String, Map<String, SerializableCookie>>();
    }
  }

  /// Delete cookies for specified [uri].
  /// This API will delete all cookies for the `uri.host`, it will ignored the `uri.path`.
  ///
  /// [withDomainSharedCookie] `true` will delete the domain-shared cookies.
  @override
  Future<void> delete(Uri uri, [bool withDomainSharedCookie = false]) async {
    final host = uri.host;
    hostCookies.remove(host);
    if (withDomainSharedCookie) {
      domainCookies.removeWhere(
          (String? domain, Map<String, Map<String, SerializableCookie>> v) =>
              uri.host.contains(domain!));
    }
  }

  /// Delete all cookies in RAM
  @override
  Future<void> deleteAll() async {
    domainCookies.clear();
    hostCookies.clear();
  }

  bool _isExpired(SerializableCookie? cookie) {
    return ignoreExpires ? false : cookie!.isExpired();
  }

  bool _check(String scheme, SerializableCookie cookie) {
    return cookie.cookie.secure && scheme == 'https' || !_isExpired(cookie);
  }

  factory NonpersistentCookieJar.createFrom(NonpersistentCookieJar otherJar) =>
      NonpersistentCookieJar()..cloneFrom(otherJar);

  void cloneFrom(NonpersistentCookieJar otherJar) {
    _deepClone(otherJar.domainCookies, domainCookies);
    _deepClone(otherJar.hostCookies, hostCookies);
  }

  static _deepClone(
      Map<String?, Map<String, Map<String, SerializableCookie>>> from,
      Map<String?, Map<String, Map<String, SerializableCookie>>> to) {
    to.clear();
    from.forEach((host, value) {
      to[host] = {};
      value.forEach((path, value) {
        to[host]![path] = {};
        value.forEach((cookieName, value) {
          to[host]![path]![cookieName] =
              SerializableCookie.fromJson(value.toJson());
        });
      });
    });
  }

  @override
  final bool ignoreExpires;
}
