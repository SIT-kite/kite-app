import 'package:kite/storage/init.dart';

enum UserType {
  /// 本、专科生（10位学号）
  undergraduate,

  /// 研究生（9位学号）
  postgraduate,

  /// 教师（4位工号）
  teacher,

  /// 未入学的新生
  freshman,
}

class AccountUtils {
  static final RegExp reUndergraduateId = RegExp(r'^(\d{6}[YGHE\d]\d{3})$');
  static final RegExp rePostgraduateId = RegExp(r'^(\d{2}6\d{6})$');
  static final RegExp reTeacherId = RegExp(r'^(\d{4})$');

  static UserType? guessUserType(String username) {
    if (username.length == 10 && reUndergraduateId.hasMatch(username.toUpperCase())) {
      return UserType.undergraduate;
    } else if (username.length == 9 && rePostgraduateId.hasMatch(username)) {
      return UserType.postgraduate;
    } else if (username.length == 4 && reTeacherId.hasMatch(username)) {
      return UserType.teacher;
    }
    return null;
  }

  static UserType? getUserType() {
    final username = Kv.auth.currentUsername;
    final ssoPassword = Kv.auth.ssoPassword;
    // 若用户名存在
    if (username != null && ssoPassword != null) {
      // 已登录用户, 账号格式一定是合法的
      return guessUserType(username)!;
    }
    // 若用户名不存在且新生用户存在
    if (Kv.freshman.freshmanAccount != null) {
      return UserType.freshman;
    }
    return null;
  }
}
