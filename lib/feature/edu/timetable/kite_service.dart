import 'package:kite/abstract/abstract_session.dart';

class KiteTimetableService {
  final ISession session;

  const KiteTimetableService(this.session);

  Future<DateTime> getSemesterDefaultStartDate() async {
    final defaultDateResponse = await session.request('/timetable/defaultDate', RequestMethod.get);
    return defaultDateResponse.data;
  }
}
