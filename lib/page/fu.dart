import 'package:flutter/material.dart';

class Fu {
  String name;
  int num;
  Fu(this.name, this.num);
}

class FuPage extends StatelessWidget {
  const FuPage({Key? key}) : super(key: key);

  Widget buildFuItem(Fu fu) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.book, size: 40),
          // SizedBox(height: 10),
          Text(fu.name),
          Text('已有${fu.num}张'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('扫福'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('扫校徽领福卡'),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(onPressed: () {}, child: Text('查看开奖结果')),
                  ],
                ),
              ),
              flex: 10,
            ),
            Expanded(
              child: Row(
                children: [
                  Fu('敬业福', 12),
                  Fu('敬业福', 12),
                  Fu('敬业福', 12),
                  Fu('敬业福', 12),
                  Fu('敬业福', 12),
                ].map((e) => Expanded(child: buildFuItem(e))).toList(),
              ),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
