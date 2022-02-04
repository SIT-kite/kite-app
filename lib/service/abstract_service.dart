import '../session/abstract_session.dart';

abstract class AService {
  final ASession session;

  const AService(this.session);
}
