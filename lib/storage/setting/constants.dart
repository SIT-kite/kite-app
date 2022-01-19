import 'package:kite/util/path.dart';

class SettingKeyConstants {
  static final homeNamespace = Path().forward('home');
  static final homeCampusKey = homeNamespace.forward('campus').toString();
  static final homeBackgroundKey = homeNamespace.forward('background').toString();
  static final homeBackgroundModeKey = homeNamespace.forward('backgroundMode').toString();

  static final authNamespace = Path().forward('auth');
  static final authCurrentUsername = authNamespace.forward('currentUsername').toString();

  static final themeNamespace = Path().forward('theme');
  static final themeColorKey = themeNamespace.forward('color').toString();
}
