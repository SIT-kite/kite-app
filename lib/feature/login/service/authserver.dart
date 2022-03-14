import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';

class AuthServerService extends AService {
  AuthServerService(ASession session) : super(session);
  Future<String> getPersonName() async {
    final response = await session.get(
      'https://authserver.sit.edu.cn/authserver/index.do',
      options: Options(
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:46.0) Gecko/20100101 Firefox/46.0',
        },
      ),
    );
    print(response.requestOptions.headers['User-Agent']);
    final result = BeautifulSoup(response.data).find('div', class_: 'auth_username')?.text;
    if (result != null) {
      return result.trim();
    }
    throw Exception('无法获取用户姓名');
  }
}
