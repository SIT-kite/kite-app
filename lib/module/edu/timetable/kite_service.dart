import 'package:kite/network/session.dart';

class KiteTimetableService {
  final ISession session;

  const KiteTimetableService(this.session);

  Future<DateTime> getSemesterDefaultStartDate() async {
    final defaultDateResponse = await session.request('/timetable/defaultDate', ReqMethod.get);
    return defaultDateResponse.data;
  }
}
