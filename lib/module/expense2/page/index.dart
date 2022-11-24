/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import 'package:flutter/material.dart';
import 'package:kite/module/expense2/entity/local.dart';

import '../using.dart';
import 'bill.dart';
import 'statistics.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int currentIndex = 0;
  TransactionType? _filter;

  Future<void> _refresh() async {
    //TODO
  }

  _buildFilterButtons() {
    final items = [
      for (final type in TransactionType.values)
        PopupMenuItem(
          value: type,
          child: Row(children: [
            Icon(
              type.icon,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
            type.localized().txt
          ]),
        )
    ];
    return PopupMenuButton(
      tooltip: i18n.filter,
      onSelected: (TransactionType v) => setState(() => _filter = v),
      itemBuilder: (_) => items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.ftype_expense.txt,
        actions: [
          currentIndex == 0 ? _buildFilterButtons() : Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: currentIndex == 0 ? const BillPage() : const StatisticsPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: i18n.bill,
            icon: const Icon(Icons.assignment_rounded),
          ),
          BottomNavigationBarItem(
            label: i18n.stats,
            icon: const Icon(Icons.data_saver_off),
          )
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}
