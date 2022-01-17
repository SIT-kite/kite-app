import 'package:flutter_test/flutter_test.dart';
import 'package:kite/util/path.dart';

void main() {
  test('test path', () {
    expect(Path().toString(), '');
    expect(Path(base: 'ABC/').toString(), 'ABC/');
    expect(Path(base: 'ABC/', separator: ',').forward('nextName').toString(), 'ABC/,nextName');
    expect(Path().forward('nextName').forward('next2').toString(), '/nextName/next2');
    expect(Path().forward('nextName').forward('next2').backward().toString(), '/nextName');

    var _namespace = Path(base: '/auth');
    var _usernameKey = _namespace.forward('username').toString();
    var _passwordKey = _namespace.forward('password').toString();
    expect(_namespace.toString(), '/auth');
    expect(_usernameKey, '/auth/username');
    expect(_passwordKey, '/auth/password');
  });
}
