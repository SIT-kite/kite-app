import 'package:flutter/material.dart';

/// AppBar上的反馈按钮
class FeedbackButton extends StatelessWidget {
  const FeedbackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await Navigator.of(context).pushNamed('/feedback');
      },
      icon: const Icon(Icons.feedback),
    );
  }
}
