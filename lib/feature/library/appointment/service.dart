import 'package:kite/feature/library/appointment/dao.dart';
import 'package:kite/feature/library/appointment/entity.dart';

class AppointmentService implements AppointmentDao {
  @override
  Future<int> apply(int period) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  Future<void> cancelApplication(int applyId) {
    // TODO: implement cancelApplication
    throw UnimplementedError();
  }

  @override
  Future<List<ApplicationRecord>> getApplication() {
    // TODO: implement getApplication
    throw UnimplementedError();
  }

  @override
  Future<String> getApplicationCode(int applyId) {
    // TODO: implement getApplicationCode
    throw UnimplementedError();
  }

  @override
  Future<List<AvailablePeriodRecord>> getAvailable() {
    // TODO: implement getAvailable
    throw UnimplementedError();
  }

  @override
  Future<String> getNotice() {
    // TODO: implement getNotice
    throw UnimplementedError();
  }

  @override
  Future<void> updateApplication(int applyId, int status) {
    // TODO: implement updateApplication
    throw UnimplementedError();
  }
}
