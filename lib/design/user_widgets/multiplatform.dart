/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../user_widget/draggable.dart';

bool get _isCupertino => UniversalPlatform.isIOS || UniversalPlatform.isMacOS;
const _kDialogAlpha = 0.89;

Future<T?> show$Dialog$<T>(
  BuildContext context, {
  required WidgetBuilder make,
  bool dismissible = true,
}) async {
  if (_isCupertino) {
    return await showCupertinoDialog<T>(
      context: context,
      builder: make,
      barrierDismissible: dismissible,
    );
  } else {
    return await showDialog<T>(
      context: context,
      builder: make,
      barrierDismissible: dismissible,
    );
  }
}

class $Button$ extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const $Button$({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (_isCupertino) {
      return CupertinoButton(onPressed: onPressed, child: text.text());
    } else {
      return ElevatedButton(onPressed: onPressed, child: text.text());
    }
  }
}

class $Action$ {
  final String text;
  final bool isDefault;
  final bool warning;
  final VoidCallback? onPressed;

  const $Action$({
    required this.text,
    this.onPressed,
    this.isDefault = false,
    this.warning = false,
  });
}

class $Dialog$ extends StatelessWidget {
  final String? title;
  final $Action$ primary;
  final $Action$? secondary;

  /// Highlight the title
  final bool serious;
  final WidgetBuilder make;

  const $Dialog$({
    super.key,
    this.title,
    required this.primary,
    required this.make,
    this.secondary,
    this.serious = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget dialog;
    final second = secondary;
    if (_isCupertino) {
      dialog = CupertinoAlertDialog(
        title: title?.text(style: TextStyle(fontWeight: FontWeight.w600, color: serious ? context.$red$ : null)),
        content: make(context),
        actions: [
          if (second != null)
            CupertinoDialogAction(
              isDestructiveAction: second.warning,
              isDefaultAction: second.isDefault,
              onPressed: () {
                second.onPressed?.call();
              },
              child: second.text.text(),
            ),
          CupertinoDialogAction(
            isDestructiveAction: primary.warning,
            isDefaultAction: primary.isDefault,
            onPressed: () {
              primary.onPressed?.call();
            },
            child: primary.text.text(),
          )
        ],
      );
    } else {
      // For other platform
      dialog = AlertDialog(
        backgroundColor: context.theme.dialogBackgroundColor.withOpacity(_kDialogAlpha),
        title: title?.text(style: TextStyle(fontWeight: FontWeight.w600, color: serious ? context.$red$ : null)),
        content: make(context),
        actions: [
          CupertinoButton(
              onPressed: () {
                primary.onPressed?.call();
              },
              child: primary.text.text(
                style: TextStyle(
                  color: primary.warning ? context.$red$ : null,
                  fontWeight: primary.isDefault ? FontWeight.w600 : null,
                ),
              )),
          if (second != null)
            CupertinoButton(
              onPressed: () {
                second.onPressed?.call();
              },
              child: second.text.text(
                style: TextStyle(
                  color: second.warning ? context.$red$ : null,
                  fontWeight: second.isDefault ? FontWeight.w600 : null,
                ),
              ),
            )
        ],
        actionsAlignment: MainAxisAlignment.spaceEvenly,
      );
    }
    if (UniversalPlatform.isDesktop) {
      dialog = OmniDraggable(child: dialog);
    }
    return dialog;
  }
}

class $TextField$ extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autofocus;

  /// On Cupertino, it's a candidate of placeholder.
  /// On Material, it's the [InputDecoration.labelText]
  final String? labelText;
  final TextInputAction? textInputAction;

  const $TextField$({
    super.key,
    this.controller,
    this.autofocus = false,
    this.placeholder,
    this.labelText,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (_isCupertino) {
      return CupertinoTextField(
          controller: controller,
          autofocus: autofocus,
          placeholder: placeholder ?? labelText,
          textInputAction: textInputAction,
          prefix: prefixIcon,
          suffix: suffixIcon,
          decoration: const BoxDecoration(
            color: CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.white,
              darkColor: CupertinoColors.darkBackgroundGray,
            ),
            border: _kDefaultRoundedBorder,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          style: CupertinoTheme.of(context).textTheme.textStyle);
    } else {
      return TextFormField(
        controller: controller,
        autofocus: autofocus,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          hintText: placeholder,
          icon: prefixIcon,
          labelText: labelText,
          suffixIcon: suffixIcon,
        ),
      );
    }
  }
}

const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0xAAA0A0A0),
  ),
  width: 1.0,
);
const Border _kDefaultRoundedBorder = Border(
  top: _kDefaultRoundedBorderSide,
  bottom: _kDefaultRoundedBorderSide,
  left: _kDefaultRoundedBorderSide,
  right: _kDefaultRoundedBorderSide,
);

extension ColorEx on BuildContext {
  Color get $red$ => _isCupertino ? CupertinoDynamicColor.resolve(CupertinoColors.systemRed, this) : Colors.redAccent;
}
