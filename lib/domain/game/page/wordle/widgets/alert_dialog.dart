/*
 * 代码来源：
 * https://github.com/nimone/wordle
 * 版权归原作者所有.
 */

import 'package:flutter/material.dart';

Future showAlertDialog(
  BuildContext context, {
  required String title,
  required List<Widget> content,
  required String actionText,
  required Function() onAction,
}) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Center(child: Text(title)),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: content,
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onAction();
            },
            child: Text(actionText),
          ),
        ),
      ],
    ),
  );
}
