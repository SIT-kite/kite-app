import 'package:dio/dio.dart';
import 'package:kite/service/abstract_session.dart';
import 'package:kite/util/logger.dart';

class LibrarySession extends DefaultSession {
  LibrarySession(Dio dio) : super(dio) {
    Log.info('初始化LibrarySession');
  }
}
