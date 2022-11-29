import 'package:flutter/material.dart';
import '../using.dart';

Widget buildButton(BuildContext ctx, String text, {VoidCallback? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: ctx.textTheme.titleLarge,
      ),
    ),
  );
}

extension Wrapper on Widget{
  Widget vwrap() {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: this,);
  }
}