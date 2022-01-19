// Rule of student id.
final RegExp reStudentId = RegExp(r'^((\d{9})|(\d{6}[YGHE\d]\d{3}))$');

String? studentIdValidator(String? username) {
  if (username != null && username.isNotEmpty) {
    // When user complete his input, check it.
    if (((username.length == 9 || username.length == 10) && !reStudentId.hasMatch(username)) || username.length > 10) {
      return '学号格式不正确';
    }
  }
  return null;
}
