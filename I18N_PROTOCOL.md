# I18n and L10n

## Toolchain

SIT-Kite
utilized [flutter_localizations](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
and [intl](https://github.com/dart-lang/intl) for internationalization and localization.

By running the commands blow, the mapped-classes of all languages will be generated.

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

## Internationalization Protocol

I18n aims at building a flexible system/scaffold for the collaboration of programming and localization.

### Naming the Translation Key

1️⃣ Generally, keep the translation key following
the [dart variable naming convention](https://dart.dev/guides/language/effective-dart/style).

``` json
// Good
"id": "ID",
"phoneNumber" : "Phone Number"

// Bad
"Address": "Address",
"TEL": "Tel."
```

2️⃣ For frequent words and phrases used in real life or computer specification,
use them in naming unambiguously.

``` json
// Good
""
```

3️⃣ Use the common abbreviation instead of a long phrase or any word that has a conventional abbreviation.

``` json
// Good
"food4Cat":"The food for cats",
"copy2clipboard" : "Copy to Clipboard",
"displayPwd": "Show password"

// Bad
"AddInformation" "Add Information", // use "Info" instead
""
```

4️⃣ Avoid third-person singular verbs and plural nouns under unnecessary circumstances.

``` json
// Good
"opNotSupport" : "This operation doesn't support",
"catNumber": "Number of cats",

// Bad
"operationDoesntSupport" : "This operation doesn't support",
"catsNumber": "Number of cats"
```

5️⃣ Use formal words instead of phrases all the time, unless there is a frequent word short enough.

``` json
// Good
"remove" : "Remove",
"popeleNumber" : "Number of people",

// Bad
"getRidOf" : "Remove",
"numberOfPeople" : "Number of people",
```

### Used in controls

1️⃣ For the toast, pop-up and flash, suffix the translation key with:

- `Tip`: If users did well. To tip users something. e.g.: `ChangedPassowrdTip`, `UnsavedChangeTip`
- `Warn`: If users did something wrong. e.g.: `PhoneNumberInputIsEmptyWarn`.
- `Error`: If an error appeared. e.g.: `DisconnectedError`,`NetworkTimeoutError`.

2️⃣ For any request dialog, suffix the translation key with:

- `Request`: If app wants users to do something. e.g.: `ChangePasswordRequest`,`AddPersonalInfoRequest`

### Formatting Overloading

## Localization Protocol

### Language style

- For English: Perform standard words.
- For Chinese: Perform friendly and cute words.

Reduce the programming specific terms and help users understand what happened more clearly.

``` kotlin
// Good
"""
The network seems in trouble.
Your application for suspension isn't sent. Please try again later.
"""

"""
Something is wrong. Please try again later.
"""

// Bad
"""
ConnectionTimeOutException at stacktrace....
Your Operation failed.
"""

"""
Unknown exception. Your opeartion was cancelled.
"""
```

### Editing .arb File

Keep the order of other l10n files identical to the [template l10n file](lib/l10n/app_en.arb),
hereinafter referred to as `template`.

It'd be better to attach a description for every translation entry, as mentioned below, in `template`
to hint localization workers the usage of the entry.

``` json
"cantLaunchQqSo2Clipboard": "QQ number has been copied because QQ isn't available.",
"@cantLaunchQqSo2Clipboard": {
  "description": "Used in Freshman vCard when QQ.app can't be launched."
}
```

Use string-format syntax to help workers organize the word order for all languages,
such as English, Chinese and Japanese.

``` json
"dormitoryDetailed": "Room {room} Bed {bed} {building}",
"@dormitoryDetailed": {
  "placeholders": {
    "room": {
      "type": "int",
      "example": "401"
    },
    "bed": {
      "type": "String",
      "example": "4"
    },
    "building": {
      "type": "String"
    }
  }
}
```

Do not copy `description` and `placeholders` from meta keys, prefixed with `@`, in `template` to a concrete
language one.
