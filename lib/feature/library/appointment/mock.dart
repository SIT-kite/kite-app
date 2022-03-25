import 'dao.dart';
import 'entity.dart';

class AppointmentMock implements AppointmentDao {
  @override
  Future<int> apply(int period) async {
    return 0;
  }

  @override
  Future<void> cancelApplication(int applyId) async {}

  @override
  Future<List<ApplicationRecord>> getApplication() async {
    return [];
  }

  @override
  Future<String> getApplicationCode(int applyId) async {
    return "";
  }

  @override
  Future<List<AvailablePeriodRecord>> getAvailable() async {
    return [];
  }

  @override
  Future<String> getNotice() async {
    return "这是图书馆公告";
  }

  @override
  Future<void> updateApplication(int applyId, int status) async {}
}
