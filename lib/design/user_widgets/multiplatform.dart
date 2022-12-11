import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../user_widget/draggable.dart';

bool get _isCupertino => true || UniversalPlatform.isIOS || UniversalPlatform.isMacOS;
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
  final VoidCallback? onPressed;

  const $Action$({required this.text, this.onPressed});
}

class $Dialog$ extends StatelessWidget {
  final String? title;
  final $Action$ primary;
  final $Action$? secondary;

  /// Highlight the primary button
  final bool highlight;

  /// Highlight the title
  final bool serious;
  final WidgetBuilder make;

  const $Dialog$({
    super.key,
    this.title,
    required this.primary,
    required this.make,
    this.secondary,
    this.highlight = false,
    this.serious = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget dialog;
    final second = secondary;
    if (_isCupertino) {
      dialog = CupertinoAlertDialog(
        title: title?.text(style: TextStyle(fontWeight: FontWeight.bold, color: serious ? Colors.redAccent : null)),
        content: make(context),
        actions: [
          if (second != null)
            CupertinoDialogAction(
              onPressed: () {
                second.onPressed?.call();
              },
              child: second.text.text(),
            ),
          CupertinoDialogAction(
            isDestructiveAction: highlight,
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
        title: title?.text(style: TextStyle(fontWeight: FontWeight.bold, color: serious ? Colors.redAccent : null)),
        content: make(context),
        actions: [
          CupertinoButton(
              onPressed: () {
                primary.onPressed?.call();
              },
              child: primary.text.text(
                style: highlight ? const TextStyle(color: Colors.redAccent) : null,
              )),
          if (second != null)
            CupertinoButton(
              onPressed: () {
                second.onPressed?.call();
              },
              child: second.text.text(),
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
