import 'dart:convert';

import 'package:kite/network/session.dart';

import '../dao/Freshman.dart';
import '../entity/info.dart';
import '../entity/relationship.dart';
import '../entity/statistics.dart';

class FreshmanService implements FreshmanDao {
  final ISession session;

  const FreshmanService(this.session);

  @override
  Future<FreshmanInfo> getInfo() async {
    final response = await session.request('', ReqMethod.get);
    return FreshmanInfo.fromJson(response.data);
  }

  @override
  Future<void> update({Contact? contact, bool? visible}) async {
    await session.request('/update', ReqMethod.put, data: {
      if (contact != null) 'yellow_pages': jsonEncode(contact.toJson()),
      if (visible != null) 'visible': visible,
    });
  }

  @override
  Future<List<Mate>> getRoommates() async {
    final response = await session.request('/roommate', ReqMethod.get);
    List<dynamic> roommates = response.data['roommates']!;
    return roommates.map((e) => Mate.fromJson(e)).toList();
  }

  @override
  Future<List<Familiar>> getFamiliars() async {
    final response = await session.request('/familiar', ReqMethod.get);
    List<dynamic> fellows = response.data['peopleFamiliar']!;
    return fellows.map((e) => Familiar.fromJson(e)).toList();
  }

  @override
  Future<List<Mate>> getClassmates() async {
    final response = await session.request('/classmate', ReqMethod.get);
    List<dynamic> classmate = response.data['classmates']!;
    return classmate.map((e) => Mate.fromJson(e)).toList();
  }

  @override
  Future<Analysis> getAnalysis() async {
    final response = await session.request('/analysis', ReqMethod.get);
    return Analysis.fromJson(response.data['freshman']);
  }

  @override
  Future<void> postAnalysisLog() async {
    await session.request('/analysis/log', ReqMethod.post);
  }
}
