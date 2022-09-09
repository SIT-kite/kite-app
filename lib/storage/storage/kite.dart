import 'package:kite/common/entity/kite_user.dart';

import '../dao/kite.dart';
import 'common.dart';

class KiteStorageKeys {
  static const _namespace = '/kite';
  static const userProfile = '$_namespace/userProfile';
}

class KiteStorage extends JsonStorage implements KiteStorageDao {
  KiteStorage(super.box);

  @override
  KiteUser? get userProfile => getModel(KiteStorageKeys.userProfile, KiteUser.fromJson);

  @override
  set userProfile(KiteUser? foo) => setModel<KiteUser>(KiteStorageKeys.userProfile, foo, (e) => e.toJson());
}
