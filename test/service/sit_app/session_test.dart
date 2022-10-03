import 'package:kite/module/sit_app/init.dart';
import 'package:kite/mock/index.dart';

void main() async {
  await init();
  await loginSitApp();
  final service = SitAppInitializer.arriveCodeService;
  test('test arrive code', () async {
    print(await service.arrive('FXxzl0001'));
  });
}
