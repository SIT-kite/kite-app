import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

extension DialogEx on BuildContext {
  /// return: whether the button was hit
  Future<bool> showTip({required String title, required String desc, required String ok}) async {
    return showAnyTip(title: title, make: (_) => desc.text(style: const TextStyle()), ok: ok);
  }

  Future<bool> showAnyTip({required String title, required WidgetBuilder make, required String ok}) async {
    final confirm = await showDialog(
      context: this,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: make(ctx),
        actions: [
          Align(
              alignment: Alignment.bottomCenter,
              child: CupertinoButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text(ok))),
        ],
      ),
    );
    return confirm == true;
  }

  Future<bool?> showRequest(
      {required String title,
      required String desc,
      required String yes,
      required String no,
      bool highlight = false}) async {
    return await showAnyRequest(title: title, make: (_) => desc.text(style: const TextStyle()), yes: yes, no: no);
  }

  Future<bool?> showAnyRequest(
      {required String title,
      required WidgetBuilder make,
      required String yes,
      required String no,
      bool highlight = false}) async {
    final index = await showDialog(
      context: this,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: make(ctx),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
          )
        ],
      ),
    );
    if (index == 0) {
      return true;
    } else if (index == 1) {
      return false;
    } else {
      return null;
    }
  }

  Future<dynamic> showSheet(WidgetBuilder builder) async {
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

typedef PickerActionWidgetBuilder = Widget Function(BuildContext context, int? curSelectedIndex);
