import 'package:kite/network/session.dart';

import 'interface.dart';
import 'mock.dart';

class FunctionOverrideInitializer {
  static late FunctionOverrideServiceDao cachedService;

  static void init({
    required ISession kiteSession,
    required FunctionOverrideStorageDao storageDao,
  }) {
/*    cachedService = FunctionOverrideCachedService(
      serviceDao: FunctionOverrideService(kiteSession),
      storageDao: storageDao,
    );*/
    // TODO: Temporarily disabled for I18n development
    cachedService = FunctionOverrideDisabled();
    // cachedService = FunctionOverrideMock();
  }
}
