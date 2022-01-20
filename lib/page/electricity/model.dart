import 'package:flutter/material.dart';

Future<void> buildModel(context, String text) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Text(text),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('知道啦!'),
          ),
        ],
      );
    },
  );
}
