import 'dart:typed_data';

import 'package:kite/mock/fu.dart';

void main() async {
  final image = Uint8List.fromList([]);
  final fuDao = FuMock();
  for (final _ in Iterable.generate(5)) {
    await fuDao.upload(image);
  }
}
