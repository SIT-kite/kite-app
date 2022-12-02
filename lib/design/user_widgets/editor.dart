import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/l10n/extension.dart';
import 'package:rettulf/buildcontext/show.dart';
import 'package:rettulf/rettulf.dart';

class Editor {
  static bool isSupport(dynamic test) {
    return test is int || test is String || test is bool;
  }

  static Future<dynamic> showAnyEditor(BuildContext ctx, dynamic initial,
      {String? desc, bool readonlyIfNotSupport = true}) async {
    if (initial is int) {
      return await showIntEditor(ctx, desc, initial);
    } else if (initial is String) {
      return await showStringEditor(ctx, desc, initial);
    } else if (initial is bool) {
      return await showBoolEditor(ctx, desc, initial);
    } else if (readonlyIfNotSupport) {
      return await showReadonlyEditor(ctx, desc, initial);
    } else {
      throw UnsupportedError("Editing $initial is not supported.");
    }
  }

  static Future<bool> showBoolEditor(BuildContext ctx, String? desc, bool initial) async {
    final $value = ValueNotifier(initial);
    final isSubmit = await showEditorSkeleton(
      ctx,
      (context) => ListTile(
        title: desc.text(style: ctx.textTheme.bodyText2),
        trailing: $value <<
            (ctx, v, _) {
              return CupertinoSwitch(
                value: v,
                onChanged: (newValue) {
                  $value.value = newValue;
                },
              );
            },
      ),
    );
    if (isSubmit) {
      return $value.value;
    } else {
      return initial;
    }
  }

  static Future<String> showStringEditor(BuildContext ctx, String? desc, String initial) async {
    final controller = TextEditingController(text: initial);
    final lines = initial.length ~/ 40 + 1;
    final isSubmit = await showEditorSkeleton(
        ctx,
        title: desc,
        (context) => TextFormField(
              maxLines: lines,
              controller: controller,
              style: ctx.textTheme.bodyMedium,
            ));
    if (isSubmit) {
      return controller.text;
    } else {
      return initial;
    }
  }

  static Future<void> showReadonlyEditor(BuildContext ctx, String? desc, dynamic value) async {
    await showEditorSkeleton(ctx, title: desc, readonly: true, (context) => value.toString().text().scrolled());
  }

  static Future<int> showIntEditor(BuildContext ctx, String? desc, int initial) async {
    int number = initial;
    final controller = TextEditingController(text: number.toString());
    final isSubmit = await showEditorSkeleton(
        ctx,
        title: desc,
        (context) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  child: const Icon(Icons.remove),
                  onPressed: () {
                    number -= 1;
                    controller.text = number.toString();
                  },
                ),
                TextFormField(
                  controller: controller,
                  onChanged: (v) {
                    final newV = int.tryParse(v);
                    if (newV != null) {
                      number = newV;
                    }
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ).sized(width: 100, height: 50),
                CupertinoButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    number += 1;
                    controller.text = number.toString();
                  },
                ),
              ],
            ));
    if (isSubmit) {
      return number;
    } else {
      return initial;
    }
  }

  static Future<bool> showEditorSkeleton(BuildContext ctx, WidgetBuilder make,
      {String? title, bool readonly = false}) async {
    final isSubmit = await ctx.showDialog(builder: (ctx) {
      final Widget action;
      if (readonly) {
        action = Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          CupertinoButton(
              onPressed: () {
                ctx.navigator.pop(false);
              },
              child: i18n.close.text(style: const TextStyle(color: Colors.redAccent))),
        ]);
      } else {
        action = Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          CupertinoButton(
              onPressed: () {
                ctx.navigator.pop(true);
              },
              child: i18n.submit.text(style: const TextStyle(color: Colors.redAccent))),
          CupertinoButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: i18n.cancel.text(),
          )
        ]);
      }
      return AlertDialog(
          title: title?.text(style: const TextStyle(fontWeight: FontWeight.bold)),
          content: make(ctx),
          actions: [action]);
    });
    return isSubmit == true;
  }
}
