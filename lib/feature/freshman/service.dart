import 'package:dio/dio.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/feature/freshman/dao.dart';
import 'package:kite/feature/freshman/entity.dart';
import 'package:kite/mock/index.dart';

class FreshmanService extends AService implements FreshmanDao {
  FreshmanService(super.session);

  @override
  Future<FreshmanInfo> getInfo() async {
    Response response = await session.get('');
    return FreshmanInfo.fromJson(response.data);
  }

  @override
  Future<void> update({Contact? contact, bool? visible}) async {
    await session.request('/update', 'PUT', data: {
      if (contact != null) 'contact': contact.toJson(),
      if (visible != null) 'visible': visible,
    });
  }

  @override
  Future<List<Mate>> getRoommates() async {
    Response response = await session.get('/roommate');
    List<dynamic> roommates = response.data['roommates']!;
    return roommates.map((e) => Mate.fromJson(e)).toList();
  }

  @override
  Future<List<Familiar>> getFamiliars() async {
    Response response = await session.get('/familiar');
    List<dynamic> fellows = response.data['peopleFamiliar']!;
    return fellows.map((e) => Familiar.fromJson(e)).toList();
  }

  @override
  Future<List<Mate>> getClassmates() async {
    Response response = await session.get('/classmate');
    List<dynamic> classmate = response.data['classmates']!;
    return classmate.map((e) => Mate.fromJson(e)).toList();
  }

  @override
  Future<Analysis> getAnalysis() async {
    Response response = await session.get('/analysis');
    return Analysis.fromJson(response.data['freshman']);
  }

  @override
  Future<void> postAnalysisLog() async {
    await session.post('/analysis/log');
  }
}
