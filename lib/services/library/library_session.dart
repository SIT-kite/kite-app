import 'package:dio/src/dio.dart';
import 'package:kite/services/abstract_session.dart';

class LibrarySession extends DefaultSession {
  LibrarySession(Dio dio) : super(dio);
}
