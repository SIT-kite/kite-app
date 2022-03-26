import 'package:flutter_test/flutter_test.dart';
import 'package:kite/util/range.dart';

void main() {
  test('range', () {
    expect(range(10).toList(), List.generate(10, (index) => index));
    expect(range(10.0).toList(), List.generate(10, (index) => index.toDouble()));
    expect(range(4, 7).toList(), [4, 5, 6]);
    expect(range(0, 10, 2).toList(), [0, 2, 4, 6, 8]);
  });
}
