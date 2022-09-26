import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';

class KiteTimetableService extends AService {
  KiteTimetableService(super.session);

  Future<DateTime> getSemesterDefaultStartDate() async {
    final defaultDateResponse = await session.request('/timetable/defaultDate', RequestMethod.get);
    return defaultDateResponse.data;
  }
}
