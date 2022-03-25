import 'package:kite/mock/index.dart';

import 'network.dart';

void main() {
  test('network test', () async {
    var a = await Network.login('', '');
    Log.info(a.toJson());
  });
  test('network test', () async {
    var a = await Network.checkStatus();
    Log.info(a.toJson());
  });
}
