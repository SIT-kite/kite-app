import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kite/pages/library/constants.dart';
import 'package:kite/pages/library/search_delegate.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  /// 随机获取一个名句
  Saying _getRandomSaying() {
    int size = Saying.sayings.length;
    int index = Random.secure().nextInt(size);
    return Saying.sayings[index];
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('图书馆'),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(context: context, delegate: SearchBarDelegate());
          },
          icon: const Icon(
            Icons.search,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.person_pin,
          ),
        ),
      ],
    );
  }

  Widget _buildSayingWidget(
    Saying saying, {
    double? width,
  }) {
    return Column(
      children: saying.text.split('，').map((e) {
            return SizedBox(
              width: width,
              child: Center(
                child: Text(e),
              ),
            );
          }).toList() +
          [
            const SizedBox(height: 20),
            SizedBox(
              width: width,
              child: Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  "——— ${_getRandomSaying().sayer}",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          ],
    );
  }

  Widget _buildBody(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var imageWidth = screenWidth * 0.6;
    var sayingWidth = screenWidth * 0.5;
    var saying = _getRandomSaying();
    return Center(
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            SizedBox(
              width: imageWidth,
              child: const Image(
                image: AssetImage("assets/library/saying.png"),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            _buildSayingWidget(
              saying,
              width: sayingWidth,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }
}
