import 'package:flutter/material.dart';

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
      {required String title, required String desc, required String yes, required String no}) async {
    final index = await showDialog(
      context: this,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(desc, style: const TextStyle()),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: () {
                Navigator.of(ctx).pop(0);
              }, child: Text(yes)),
              TextButton(onPressed: () {
                Navigator.of(ctx).pop(1);
              }, child: Text(no))
            ],
          )
        ],
      ),
    );
    return index == 0;
  }
}
