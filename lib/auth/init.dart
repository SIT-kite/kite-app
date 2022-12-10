import 'dao/credential.dart';
import 'storage/credential.dart';
import 'using.dart';

class AuthInit {
  static late CredentialDao credential;

  void init({required Box<dynamic> box}) {
    credential = CredentialStorage(box);
  }
}
