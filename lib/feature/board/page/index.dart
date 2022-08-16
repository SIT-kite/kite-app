import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../kite/init.dart';
import '../service.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({Key? key}) : super(key: key);

  Widget buildView() {
    // Test code
    return GridView.builder(
      gridDelegate: SliverWovenGridDelegate.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        pattern: [
          const WovenGridTile(1),
          const WovenGridTile(
            13 / 16,
            crossAxisRatio: 0.9,
            alignment: AlignmentDirectional.center,
          ),
        ],
      ),
      itemBuilder: (context, i) {
        return Card(
          child: Text(i.toString()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = BoardService(KiteInitializer.kiteSession);

    return Scaffold(
      appBar: AppBar(
        title: const Text("风景墙"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload),
        onPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
        child: buildView(),
      ),
    );
  }
}
