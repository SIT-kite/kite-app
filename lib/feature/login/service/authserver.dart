import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';

class AuthServerService extends AService {
  AuthServerService(ASession session) : super(session);
  Future<String> getPersonName() async {
    final response = await session.get('https://authserver.sit.edu.cn/authserver/index.do');
    final result = BeautifulSoup(response.data).find('div', class_: 'auth_username')?.text ?? '';
    return result.trim();
  }
}
