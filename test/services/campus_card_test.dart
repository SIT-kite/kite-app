import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/campus_card.dart';

void main() {
  test('cmapus card request test', () async {
    final cardInfo = await getCardInfo(0x74B91E2E);

    print(cardInfo);
  });
}
