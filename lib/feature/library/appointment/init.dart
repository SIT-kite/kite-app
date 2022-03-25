import 'package:kite/feature/library/appointment/dao.dart';
import 'package:kite/feature/library/appointment/service.dart';
import 'package:kite/session/kite_session.dart';

class LibraryAppointmentInitializer {
  static late KiteSession kiteSession;
  static late AppointmentDao appointmentService;
  static void init({
    required KiteSession kiteSession,
  }) {
    LibraryAppointmentInitializer.kiteSession = kiteSession;
    appointmentService = AppointmentService(kiteSession);
  }
}
