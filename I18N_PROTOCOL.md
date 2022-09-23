# I18n and L10n

### Toolchain

SIT-Kite
utilized [flutter_localizations](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
and [intl](https://github.com/dart-lang/intl) for internationalization and localization.

You can generate the mapped-classes of all languages by running the command blow.

``` shell
% flutter gen-l10n
```

And then the mapped-classes will be found in this [dart-generated](.dart_tool/flutter_gen/gen_l10n) folder.

To reference them, you should import those dart files first:

``` dart
import 'package:kite/l10n/extension.dart';
```

And then access any translation key you want:

``` dart
var response = i18n.yes;
response = i18n.no;
```

You can also add, remove, modify or even support a new language in the [l10n](lib/l10n) folder.

The [app_en.arb](lib/l10n/app_en.arb) is the template language, which means any structural change will affect other
languages.

More readings:
[A Guide to Flutter Localization](https://phrase.com/blog/posts/flutter-localization/),
[Flutter ARB file (.arb)](https://localizely.com/flutter-arb/),
[Flutter Localization with ARB made simple](https://medium.com/@angga.arifandi/flutter-localization-with-arb-made-simple-c03da609dcaf)

### Internationalization Protocol



### Localization Protocol
