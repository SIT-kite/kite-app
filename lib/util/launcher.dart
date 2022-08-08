import 'package:kite/util/rule.dart';

typedef OnLaunchCallback = void Function(String);

class LaunchScheme {
  final Rule<String> launchRule;
  final OnLaunchCallback onLaunch;

  const LaunchScheme({
    required this.launchRule,
    required this.onLaunch,
  });
}

class SchemeLauncher {
  List<LaunchScheme> schemes;
  OnLaunchCallback? onNotFound;
  SchemeLauncher({
    this.schemes = const [],
    this.onNotFound,
  });

  void launch(String schemeText) {
    for (final scheme in schemes) {
      if (scheme.launchRule.accept(schemeText)) {
        scheme.onLaunch(schemeText);
        return;
      }
    }

    if (onNotFound != null) {
      onNotFound!(schemeText);
    }
  }
}
