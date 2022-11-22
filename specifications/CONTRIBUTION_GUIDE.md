# Contribution Guide

Kite is developed and maintained by the SIT YiBan Workstation,
hereinafter referred to as Kite Team.

Please also check:

- [The terms of Kite](TERM.md)
- [The structure of Kite project](STRUCTURE.MD)
- [The abbreviation Kite used](ABBREVIATION.md)
- [The internationalization protocol](I18N_PROTOCOL.md)

## Getting Started

Clone the repository to a local folder.
Note: you have to put it in a folder named as `kite`.

``` shell
git clone https://github.com/SIT-kite/kite-app kite
cd ./kite
```

Then run the necessary build steps.

``` shell
flutter pub get

flutter pub run build_runner build
flutter pub run flutter_native_splash:create
```

Finally, build the Kite based on your platform.

```shell
# On Windows
flutter build winodws   # build for Windows
flutter build apk       # build for Android
# On macOS
flutter build macos     # build for macOS
flutter build ios       # build for iOS
flutter build apk       # build for Android
# On Linux
flutter build linux     # build for Linux
flutter build apk       # build for Android
```

### iOS Build

Kite for iOS requires `Xcode 13.4.1`, the latest Xcode 13.
You can download it [here](https://developer.apple.com/download/all/?q=Xcode%2013.4.1).

Be aware that Xcode 14 or higher doesn't work due to the compatibility issue of some dependencies.


## Dependency

### Flutter

Kite Team always works with the latest Flutter.
As of press time, Kite Team uses:

- Flutter 3.3.8

## Code Style

### Dart

As to formatting, please follow what `dart format` does.
The dedicated configuration for Kite is `line length: 120`.
You can run the command below to format the whole project by this principle.

```shell
dart format . -l 120
```

As to naming principle, please follow
the [official naming convention](https://dart.dev/guides/language/effective-dart/style).

To be flexible and easy to reconstruct,
in side of a [module](STRUCTURE.md#module), `relative import` should be applied,
meanwhile, `absolute import` should be applied outside.

### Json

As to formatting, the indent is 2 spaces.

As to naming, please keep the key `lowerCamelCase`, which can be mapped to a valid dart variable name.
