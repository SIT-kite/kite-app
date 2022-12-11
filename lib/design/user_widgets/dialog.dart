import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rettulf/rettulf.dart';

import 'multiplatform.dart';

typedef PickerActionWidgetBuilder = Widget Function(BuildContext context, int? curSelectedIndex);

extension DialogEx on BuildContext {
  /// return: whether the button was hit
  Future<bool> showTip({
    required String title,
    required String desc,
    required String ok,
    bool highlight = false,
    bool serious = false,
  }) async {
    return showAnyTip(
      title: title,
      make: (_) => desc.text(style: const TextStyle()),
      ok: ok,
      highlight: false,
      serious: serious,
    );
  }

  Future<bool> showAnyTip({
    required String title,
    required WidgetBuilder make,
    required String ok,
    bool highlight = false,
    bool serious = false,
  }) async {
    final dynamic confirm = await show$Dialog$(
      this,
      make: (ctx) => $Dialog$(
          title: title,
          highlight: highlight,
          serious: serious,
          make: make,
          primary: $Action$(
            text: ok,
            onPressed: () {
              ctx.navigator.pop(true);
            },
          )),
    );
    return confirm == true;
  }

  Future<bool?> showRequest({
    required String title,
    required String desc,
    required String yes,
    required String no,
    bool highlight = false,
    bool serious = false,
  }) async {
    return await showAnyRequest(
      title: title,
      make: (_) => desc.text(style: const TextStyle()),
      yes: yes,
      no: no,
      highlight: highlight,
      serious: serious,
    );
  }

  Future<bool?> showAnyRequest({
    required String title,
    required WidgetBuilder make,
    required String yes,
    required String no,
    bool highlight = false,
    bool serious = false,
  }) async {
    return await show$Dialog$(
      this,
      make: (ctx) => $Dialog$(
        title: title,
        highlight: highlight,
        serious: serious,
        make: make,
        primary: $Action$(
          text: yes,
          onPressed: () {
            ctx.navigator.pop(true);
          },
        ),
        secondary: $Action$(
          text: no,
          onPressed: () {
            ctx.navigator.pop(false);
          },
        ),
      ),
    );
  }

  Future<dynamic> showSheet(WidgetBuilder builder) async {
    return await showCupertinoModalBottomSheet(
      context: this,
      builder: builder,
    );
    return await showModalBottomSheet(
        context: this,
        isScrollControlled: true,
        shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(48))),
        builder: builder);
  }

  Future<int?> showPicker(
      {required int count,
      required String ok,
      bool Function(int? selected)? okEnabled,
      double targetHeight = 240,
      bool highlight = false,
      FixedExtentScrollController? controller,
      List<PickerActionWidgetBuilder>? actions,
      required IndexedWidgetBuilder make}) async {
    final $selected = ValueNotifier<int?>(controller?.initialItem);
    return await navigator.push(
      CupertinoModalPopupRoute(
        builder: (ctx) => CupertinoActionSheet(
            message: SizedBox(
                height: targetHeight,
                child: CupertinoPicker(
                  scrollController: controller,
                  magnification: 1.22,
                  useMagnifier: true,
                  // This is called when selected item is changed.
                  onSelectedItemChanged: (int selectedItem) {
                    $selected.value = selectedItem;
                  },
                  squeeze: 1.5,
                  itemExtent: 32.0,
                  children: List<Widget>.generate(count, (int index) {
                    return make(ctx, index);
                  }),
                )),
            actions: actions
                ?.map((e) =>
                    ValueListenableBuilder(valueListenable: $selected, builder: (ctx, value, child) => e(ctx, value)))
                .toList(),
            cancelButton: ValueListenableBuilder(
                valueListenable: $selected,
                builder: (ctx, value, child) => CupertinoButton(
                    onPressed: okEnabled?.call(value) ?? true
                        ? () {
                            Navigator.of(ctx).pop($selected.value);
                          }
                        : null,
                    child: ok.text(style: highlight ? const TextStyle(color: Colors.redAccent) : null)))),
      ),
    );
  }
}
