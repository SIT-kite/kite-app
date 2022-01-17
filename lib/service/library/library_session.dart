import 'package:dio/src/dio.dart';
import 'package:kite/service/abstract_session.dart';

class LibrarySession extends DefaultSession {
  LibrarySession(Dio dio) : super(dio);
}
