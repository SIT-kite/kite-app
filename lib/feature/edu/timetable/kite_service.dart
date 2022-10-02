import 'package:kite/network/session.dart';

class KiteTimetableService {
  final Session session;

  const KiteTimetableService(this.session);

  Future<DateTime> getSemesterDefaultStartDate() async {
    final defaultDateResponse = await session.request('/timetable/defaultDate', RequestMethod.get);
    return defaultDateResponse.data;
  }
}
