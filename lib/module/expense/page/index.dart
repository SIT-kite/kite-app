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

import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../init.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/local.dart';
import '../using.dart';
import 'bill.dart';
import 'statistics.dart';

class ExpenseTrackerPage extends StatefulWidget {
  const ExpenseTrackerPage({Key? key}) : super(key: key);

  @override
  State<ExpenseTrackerPage> createState() => _ExpenseTrackerPageState();
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {
  int currentIndex = 0;

  final cache = ExpenseTrackerInit.cache;

  final ValueNotifier<double?> $balance = ValueNotifier(null);

  List<Transaction> allRecords = [];

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await fetch(DateTime(2010), DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildAppBarTitle(context),
        centerTitle: true,
        actions: [buildMenu()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: [
          BillPage(records: allRecords),
          StatisticsPage(records: allRecords),
        ][currentIndex],
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
        onTap: (int index) => setState(() => currentIndex = index),
      ),
    );
  }

  Widget buildAppBarTitle(BuildContext ctx) {
    return $balance <<
        (ctx, v, _) {
          if (v == null) {
            return i18n.ftype_expense.text();
          } else {
            return i18n.expenseBalanceInCard(v.toStringAsFixed(2)).text();
          }
        };
  }

  void refreshRecords(List<Transaction> records) {
    if (!mounted) return;
    // 过滤支付宝的充值，否则将和圈存机叠加
    records = records.where((e) => e.type != TransactionType.topUp).toList();
    setState(() {
      allRecords = records;
      if (allRecords.isNotEmpty) {
        $balance.value = allRecords.last.balanceAfter;
      }
    });
    FireOn.expenseTracker(ExpenseTackerRefreshEvent());
  }

  Future<void> fetch(DateTime start, DateTime end) async {
    final oaCredential = Auth.oaCredential;
    if(oaCredential == null) return;
    final account = oaCredential.account;
    for (int i = 0; i < 3; i++) {
      try {
        EasyLoading.showToast(i18n.expenseToastLoading);
        allRecords = await cache.fetch(
          studentID: account,
          from: start,
          to: end,
          onLocalQuery: refreshRecords,
        );
        refreshRecords(allRecords);
        EasyLoading.showToast(i18n.expenseToastLoadSuccessful);
        return;
      } catch (_) {}
    }
    EasyLoading.showToast(i18n.expenseToastLoadFailed);
  }

  Widget buildMenu() {
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        PopupMenuItem(
          child: Text(i18n.expenseRefreshMenuButton),
          onTap: () async {
            try {
              // 关闭用户交互
              EasyLoading.instance.userInteractions = false;
              EasyLoading.show(status: i18n.expenseFetchingRecordTip);
              ExpenseTrackerInit.local
                ..clear()
                ..cachedTsEnd = null
                ..cachedTsStart = null;
              await fetch(DateTime(2010), DateTime.now());
            } catch (e, t) {
              EasyLoading.showError('${i18n.failed}: ${e.toString().split('\n')[0]}');
              Catcher.reportCheckedError(e, t);
            } finally {
              // 关闭正在加载对话框
              EasyLoading.dismiss();
              // 开启用户交互
              EasyLoading.instance.userInteractions = true;
            }
          },
        ),
      ],
    );
  }
}
