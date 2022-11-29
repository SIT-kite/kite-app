import 'package:flutter/material.dart';

extension DialogEx on BuildContext {
  Future<void> showTip(String title, String content, String buttonA) {
    return showTipDialog(this, title, content, buttonA);
  }
}

Future<void> showTipDialog(BuildContext context, String title, String content, String buttonA) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(content, style: const TextStyle()),
      actions: [
        Align(alignment: Alignment.centerRight, child: Text(buttonA)),
      ],
    ),
  );
}
