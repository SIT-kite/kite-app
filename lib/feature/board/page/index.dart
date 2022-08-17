/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
