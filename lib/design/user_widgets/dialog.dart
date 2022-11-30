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
          Align(alignment: Alignment.bottomCenter, child: ElevatedButton(onPressed: () {}, child: Text(ok))),
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
}
