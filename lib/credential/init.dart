import 'dao/credential.dart';
import 'storage/credential.dart';
import 'using.dart';

class CredentialInit {
  static late CredentialDao credential;

  static void init({required Box<dynamic> box}) {
    credential = CredentialStorage(box);
  }
}
