import 'dart:typed_data';

import 'package:kite/dao/kite/fu.dart';
import 'package:kite/entity/kite/fu.dart';
import 'package:kite/session/abstract_session.dart';

import '../abstract_service.dart';

class FuService extends AService implements FuDao {
  FuService(ASession session) : super(session);

  @override
  Future<List<MyCard>> getList() async {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future<PraiseResult> getResult() async {
    // TODO: implement getResult
    throw UnimplementedError();
  }

  @override
  Future<UploadResultModel> upload(Uint8List imageBuffer) async {
    // TODO: implement upload
    throw UnimplementedError();
  }
}
