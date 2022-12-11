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
import 'package:flutter/services.dart';
import 'package:kite/design/user_widgets/multiplatform.dart';
import 'package:kite/l10n/extension.dart';
import 'package:rettulf/buildcontext/show.dart';
import 'package:rettulf/rettulf.dart';

typedef EditorBuilder<T> = Widget Function(BuildContext ctx, String? desc, T initial);

class Editor {
  static final Map<Type, EditorBuilder> _customEditor = {};

  static registerEditor<T>(EditorBuilder<T> builder) {
    _customEditor[T] = (ctx, desc, initial) => builder(ctx, desc, initial);
  }

  static bool isSupport(dynamic test) {
    return test is int || test is String || test is bool || _customEditor.containsKey(test.runtimeType);
  }

  static Future<dynamic> showAnyEditor(BuildContext ctx, dynamic initial,
      {String? desc, bool readonlyIfNotSupport = true}) async {
    if (initial is int) {
      return await showIntEditor(ctx, desc, initial);
    } else if (initial is String) {
      return await showStringEditor(ctx, desc, initial);
    } else if (initial is bool) {
      return await showBoolEditor(ctx, desc, initial);
    } else {
      final customEditorBuilder = _customEditor[initial.runtimeType];
      if (customEditorBuilder != null) {
        final newValue = await show$Dialog$(ctx, make: (ctx) => customEditorBuilder(ctx, desc, initial));
        if (newValue != null) {
          return newValue;
        } else {
          return initial;
        }
      } else {
        if (readonlyIfNotSupport) {
          return await showReadonlyEditor(ctx, desc, initial);
        } else {
          throw UnsupportedError("Editing $initial is not supported.");
        }
      }
    }
  }

  static Future<bool> showBoolEditor(BuildContext ctx, String? desc, bool initial) async {
    final newValue = await ctx.showDialog(
        builder: (ctx) => _BoolEditor(
              initial: initial,
              desc: desc,
            ));
    if (newValue != null) {
      return newValue;
    } else {
      return initial;
    }
  }

  static Future<String> showStringEditor(BuildContext ctx, String? desc, String initial) async {
    final newValue = await ctx.showDialog(
        builder: (ctx) => _StringEditor(
              initial: initial,
              title: desc,
            ));
    if (newValue != null) {
      return newValue;
    } else {
      return initial;
    }
  }

  static Future<void> showReadonlyEditor(BuildContext ctx, String? desc, dynamic value) async {
    await ctx.showDialog(
        builder: (ctx) => _readonlyEditor(ctx, (ctx) => value.toString().text().scrolled(), title: desc));
  }

  static Future<int> showIntEditor(BuildContext ctx, String? desc, int initial) async {
    final newValue = await ctx.showDialog(
        builder: (ctx) => _IntEditor(
              initial: initial,
              title: desc,
            ));
    if (newValue == null) {
      return initial;
    } else {
      return newValue;
    }
  }
}

Widget _readonlyEditor(BuildContext ctx, WidgetBuilder make, {String? title}) {
  return $Dialog$(
      title: title,
      primary: $Action$(
          text: i18n.close,
          onPressed: () {
            ctx.navigator.pop(false);
          }),
      make: (ctx) => make(ctx));
}

class _IntEditor extends StatefulWidget {
  final int initial;
  final String? title;

  const _IntEditor({required this.initial, this.title});

  @override
  State<_IntEditor> createState() => _IntEditorState();
}

class _IntEditorState extends State<_IntEditor> {
  late TextEditingController controller;
  late int value = widget.initial;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initial.toString());
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return $Dialog$(
        title: widget.title,
        primary: $Action$(
            text: i18n.submit,
            onPressed: () {
              context.navigator.pop(value);
            }),
        secondary: $Action$(
            text: i18n.cancel,
            onPressed: () {
              context.navigator.pop(widget.initial);
            }),
        make: (ctx) => buildBody(ctx));
  }

  Widget buildBody(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CupertinoButton(
          child: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              value--;
              controller.text = value.toString();
            });
          },
        ),
        TextFormField(
          controller: controller,
          onChanged: (v) {
            final newV = int.tryParse(v);
            if (newV != null) {
              setState(() {
                value = newV;
              });
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
            setState(() {
              value++;
              controller.text = value.toString();
            });
          },
        ),
      ],
    );
  }
}

class _BoolEditor extends StatefulWidget {
  final bool initial;
  final String? desc;

  const _BoolEditor({required this.initial, this.desc});

  @override
  State<_BoolEditor> createState() => _BoolEditorState();
}

class _BoolEditorState extends State<_BoolEditor> {
  late bool value = widget.initial;

  @override
  Widget build(BuildContext context) {
    return $Dialog$(
        primary: $Action$(
            text: i18n.submit,
            onPressed: () {
              context.navigator.pop(value);
            }),
        secondary: $Action$(
            text: i18n.cancel,
            onPressed: () {
              context.navigator.pop(widget.initial);
            }),
        make: (ctx) => ListTile(
            title: widget.desc.text(style: context.textTheme.bodyText2),
            trailing: CupertinoSwitch(
              value: value,
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });
              },
            )));
  }
}

class _StringEditor extends StatefulWidget {
  final String initial;
  final String? title;

  const _StringEditor({required this.initial, this.title});

  @override
  State<_StringEditor> createState() => _StringEditorState();
}

class _StringEditorState extends State<_StringEditor> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lines = context.isPortrait ? widget.initial.length ~/ 40 + 1 : widget.initial.length ~/ 120 + 1;
    return $Dialog$(
        title: widget.title,
        primary: $Action$(
            text: i18n.submit,
            onPressed: () {
              context.navigator.pop(controller.text);
            }),
        secondary: $Action$(
            text: i18n.cancel,
            onPressed: () {
              context.navigator.pop(widget.initial);
            }),
        make: (ctx) => TextFormField(
              maxLines: lines,
              controller: controller,
              style: context.textTheme.bodyMedium,
            ));
  }
}
