import 'package:flutter_test/flutter_test.dart';
import 'package:kite/util/path.dart';

void main() {
  test('test path', () {
    expect(Path().toString(), '');
    expect(Path(base: 'ABC/').toString(), 'ABC/');
    expect(Path(base: 'ABC/', separator: ',').forward('nextName').toString(), 'ABC/,nextName');
    expect(Path().forward('nextName').forward('next2').toString(), '/nextName/next2');
    expect(Path().forward('nextName').forward('next2').backward().toString(), '/nextName');
  });
}
