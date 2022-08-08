import 'package:dio/dio.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/feature/freshman/dao.dart';
import 'package:kite/feature/freshman/entity.dart';

class FreshmanService extends AService implements FreshmanDao {
  FreshmanService(super.session);

  @override
  Future<FreshmanInfo> getInfo(String account, String secret) async {
    Response response = await session.get(
      '/freshman/$account',
      queryParameters: {'secret': secret},
    );
    return FreshmanInfo.fromJson(response.data);
  }
}
