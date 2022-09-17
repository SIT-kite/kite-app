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
import 'package:kite/component/future_builder.dart';

import '../entity.dart';
import '../init.dart';

class ElectricityPage extends StatefulWidget {
  const ElectricityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  String room = '10231001';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('电费查询'),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          balanceCard()
        ],
      ),
    );
  }

  Widget balanceCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(width: 10),
            Text(
              '余额查询',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(height: 10),
        Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
                color: Colors.blueAccent.withAlpha(70),
                borderRadius: BorderRadius.circular(10)),
            child: MyFutureBuilder<Balance>(
              future:
                  ElectricityInitializer.electricityService.getBalance(room),
              builder: (context, data) {
                return Row(
                  children: [Text(data.power.toString())],
                );
              },
            )),
      ],
    );
  }
}
