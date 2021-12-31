import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.white);
    const decoration = BoxDecoration(
        image: DecorationImage(
            image: AssetImage("welcome/background.jpg"), fit: BoxFit.cover));

    return Scaffold(
        body: SafeArea(
            child: Container(
      decoration: decoration,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 150),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('上应小风筝',
              style: textStyle.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 30)),
          Text('便利校园，一步到位',
              style: textStyle.copyWith(
                  fontWeight: FontWeight.normal, fontSize: 20)),
          const SizedBox(height: 40.0),
          OutlinedButton(
              autofocus: true,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                side: const BorderSide(width: 1, color: Colors.white),
              ),
              child: Text('登录',
                  style: textStyle.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal)),
              onPressed: () {}),
          TextButton(
              style: TextButton.styleFrom(padding: const EdgeInsets.all(0.0)),
              child: Text('我们为什么转做 App',
                  style: textStyle.copyWith(color: Colors.white)),
              onPressed: () {})
        ],
      ),
    )));
  }
}
