import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

extension DialogEx on BuildContext {
  /// return: whether the button was hit
  Future<bool> showTip({required String title, required String desc, required String ok}) async {
    final confirm = await showDialog(
      context: this,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(desc, style: const TextStyle()),
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
    final index = await showDialog(
      context: this,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(desc, style: const TextStyle()),
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
      int? initialIndex,
      double targetHeight = 240,
      required IndexedWidgetBuilder make}) async {
    int? number;
    return await navigator.push(
      CupertinoModalPopupRoute(
        builder: (ctx) => CupertinoActionSheet(
          message: SizedBox(
              height: targetHeight,
              child: CupertinoPicker(
                scrollController: initialIndex != null ? FixedExtentScrollController(initialItem: initialIndex) : null,
                magnification: 1.22,
                useMagnifier: true,
                // This is called when selected item is changed.
                onSelectedItemChanged: (int selectedItem) {
                  number = selectedItem;
                },
                squeeze: 1.5,
                itemExtent: 32.0,
                children: List<Widget>.generate(count, (int index) {
                  return make(ctx, index);
                }),
              )),
          cancelButton: CupertinoButton(
              onPressed: () {
                Navigator.of(ctx).pop(number);
              },
              child: ok.text()),
        ),
      ),
    );
  }
}
