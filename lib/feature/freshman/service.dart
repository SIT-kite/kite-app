import 'package:dio/dio.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/feature/freshman/dao.dart';
import 'package:kite/feature/freshman/entity.dart';

class FreshmanService extends AService implements FreshmanDao {
  FreshmanService(super.session);

  @override
  Future<FreshmanInfo> getInfo() async {
    Response response = await session.get('');
    return FreshmanInfo.fromJson(response.data);
  }

  @override
  Future<Analysis> getAnalysis() {
    // TODO: implement getAnalysis
    throw UnimplementedError();
  }

  @override
  Future<List<Classmate>> getClassmates() {
    // TODO: implement getClassmates
    throw UnimplementedError();
  }

  @override
  Future<List<Familiar>> getFamiliars() {
    // TODO: implement getFamiliars
    throw UnimplementedError();
  }

  @override
  Future<List<Roommate>> getRoommates() {
    // TODO: implement getRoommates
    throw UnimplementedError();
  }

  @override
  Future<void> postAnalysisLog() {
    // TODO: implement postAnalysisLog
    throw UnimplementedError();
  }

  @override
  Future<void> update({Contact? contact, bool? visible}) async {
    await session.request(
      '/update',
      'PUT',
      data: {
        if (contact != null) 'contact': contact.toJson(),
        if (visible != null) 'visible': visible,
      },
    );
  }
}
