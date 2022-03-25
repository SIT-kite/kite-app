import 'package:kite/session/kite_session.dart';

class LibraryAppointmentInitializer {
  static late KiteSession kiteSession;
  static void init({
    required KiteSession kiteSession,
  }) {
    LibraryAppointmentInitializer.kiteSession = kiteSession;
  }
}
