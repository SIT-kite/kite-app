import 'package:flutter/material.dart';

class GreetingWidget extends StatefulWidget {
  GreetingWidget({Key? key}) : super(key: key);

  @override
  _GreetingWidgetState createState() => _GreetingWidgetState();
}

class _GreetingWidgetState extends State<GreetingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const SizedBox(child: Text('此处显示天气图标')),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text('上午好，'),
              Text('今天是你在上应大的第 300 天，'),
              Text('今天晴天，没有雨。明天可能下雨。')
            ],
          ),
        ]));
  }
}
