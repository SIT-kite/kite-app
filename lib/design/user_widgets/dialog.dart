import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

extension DialogEx on BuildContext {
  Future<void> showTip({required String title, required String desc, required String ok}) async {
    await showDialog(
      context: this,
      builder: (_) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(desc, style: const TextStyle()),
        actions: [
          Align(alignment: Alignment.bottomCenter, child: ElevatedButton(onPressed: () {}, child: Text(ok).padAll(5))),
        ],
      ),
    );
    return;
  }

  Future<bool> showRequest(
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
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(0);
                  },
                  child: yes.text(style: highlight ? const TextStyle(color: Colors.redAccent) : null).padAll(5)),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(1);
                  },
                  child: no.text().padAll(5))
            ],
          )
        ],
      ),
    );
    return index == 0;
  }

  Future<dynamic> showSheet(WidgetBuilder builder) async {
    return await showModalBottomSheet(
        context: this,
        isScrollControlled: true,
        shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(48))),
        builder: builder);
  }

  Future<int?> showPicker(
      {required int count, required String ok, double tagrtHeight = 340, required IndexedWidgetBuilder make}) async {
    int? number;
    return await showSheet((ctx) => Container(
          height: tagrtHeight,
          padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: [
              Expanded(
                  child: CupertinoPicker(
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
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(number);
                  },
                  child: ok.text().padAll(5))
            ].column(),
          ),
        ));
  }
}
