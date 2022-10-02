# Contribution Guide

Kite is developed and maintained by the SIT YiBan Workstation,
hereinafter referred to as Kite Team.

## Getting Started

``` shell
git clone https://github.com/SIT-kite/kite-app kite
cd ./kite

flutter pub get

flutter pub run build_runner build
flutter pub run flutter_native_splash:create
```

## Dependency

### Flutter

Kite Team always works with the latest Flutter.
As of press time, Kite Team uses:

- Flutter 3.3.3

## Code Style

### Dart

Please follow what `dart format` does.

The dedicated configuration for Kite is:

- Line length: 120

```shell
dart format . -l 120
```
