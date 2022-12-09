import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/user_widget/draggable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import 'glassmorphic.dart';

typedef PickerActionWidgetBuilder = Widget Function(BuildContext context, int? curSelectedIndex);

const _kDialogAlpha = 0.89;

extension DialogEx on BuildContext {
  /// return: whether the button was hit
  Future<bool> showTip({
    required String title,
    required String desc,
    required String ok,
    bool highlight = false,
    bool error = false,
  }) async {
    return showAnyTip(
      title: title,
      make: (_) => desc.text(style: const TextStyle()),
      ok: ok,
      highlight: false,
      error: error,
    );
  }

  Future<bool> showAnyTip({
    required String title,
    required WidgetBuilder make,
    required String ok,
    bool highlight = false,
    bool error = false,
  }) async {
    final dynamic confirm;
    if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
      confirm = await showCupertinoModalPopup(
        context: this,
        builder: (BuildContext ctx) => CupertinoAlertDialog(
          title: title.text(style: TextStyle(fontWeight: FontWeight.bold, color: error ? Colors.redAccent : null)),
          content: make(ctx),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: highlight,
              onPressed: () {
                ctx.navigator.pop(true);
              },
              child: ok.text(),
            )
          ],
        ),
      );
    } else {
      confirm = await showDialog(
        context: this,
        builder: (ctx) {
          final dialog = AlertDialog(
              backgroundColor: theme.dialogBackgroundColor.withOpacity(_kDialogAlpha),
              title: title.text(style: TextStyle(fontWeight: FontWeight.bold, color: error ? Colors.redAccent : null)),
              content: make(ctx),
              actions: [
                CupertinoButton(
                    onPressed: () {
                      ctx.navigator.pop(true);
                    },
                    child: ok.text(style: highlight ? const TextStyle(color: Colors.redAccent) : null))
              ],
              actionsAlignment: MainAxisAlignment.spaceEvenly);
          if (UniversalPlatform.isDesktop) {
            return OmniDraggable(child: dialog);
          } else {
            return dialog;
          }
        },
      );
    }
    return confirm == true;
  }

  Future<bool?> showRequest({
    required String title,
    required String desc,
    required String yes,
    required String no,
    bool highlight = false,
    bool error = false,
  }) async {
    return await showAnyRequest(
      title: title,
      make: (_) => desc.text(style: const TextStyle()),
      yes: yes,
      no: no,
      highlight: highlight,
      error: error,
    );
  }

  Future<bool?> showAnyRequest({
    required String title,
    required WidgetBuilder make,
    required String yes,
    required String no,
    bool highlight = false,
    bool error = false,
  }) async {
    final dynamic index;
    if (UniversalPlatform.isIOS || UniversalPlatform.isMacOS) {
      index = await showCupertinoModalPopup(
        context: this,
        builder: (BuildContext ctx) => CupertinoAlertDialog(
          title: title.text(style: TextStyle(fontWeight: FontWeight.bold, color: error ? Colors.redAccent : null)),
          content: make(ctx),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(ctx).pop(1);
              },
              child: no.text(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: highlight,
              onPressed: () {
                Navigator.of(ctx).pop(0);
              },
              child: yes.text(),
            )
          ],
        ),
      );
    } else {
      index = await showDialog(
          context: this,
          builder: (ctx) {
            final dialog = AlertDialog(
                title:
                    title.text(style: TextStyle(fontWeight: FontWeight.bold, color: error ? Colors.redAccent : null)),
                backgroundColor: theme.dialogBackgroundColor.withOpacity(_kDialogAlpha),
                content: make(ctx),
                actions: [
                  CupertinoButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(0);
                      },
                      child: yes.text(style: highlight ? const TextStyle(color: Colors.redAccent) : null)),
                  CupertinoButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(1);
                      },
                      child: no.text())
                ],
                actionsAlignment: MainAxisAlignment.spaceEvenly);
            if (UniversalPlatform.isDesktop) {
              return OmniDraggable(child: dialog);
            } else {
              return dialog;
            }
          });
    }
    if (index == 0) {
      return true;
    } else if (index == 1) {
      return false;
    } else {
      return null;
    }
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
