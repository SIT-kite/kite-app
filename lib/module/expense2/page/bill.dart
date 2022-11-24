import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/module/expense2/storage/local.dart';
import 'package:kite/storage/init.dart';

import '../cache/cache.dart';
import '../entity/local.dart';
import '../init.dart';

class BillPage extends StatefulWidget {
  const BillPage({Key? key}) : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  ExpenseStorage get storage => Expense2Init.local;

  CachedExpenseGetDao get cache => Expense2Init.cache;

  List<Transaction> records = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: records.map((e) {
        return Column(
          children: [
            ListTile(
              title: Text(e.deviceName),
              subtitle: Text(DateFormat('yyyy-MM-dd  HH:mm:ss').format(e.datetime)),
              leading: Transform.scale(scale: 1.5, child: Icon(e.type.icon, color: Theme.of(context).primaryColor)),
              trailing: () {
                final delta = e.balanceAfter - e.balanceBefore;
                final text = '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(2)}';
                final color = delta > 0 ? Colors.green : Colors.red;
                return Transform.scale(
                  scale: 1.2,
                  child: Text(
                    text,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                );
              }(),
            ),
            const Divider(),
          ],
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      records = await cache.fetch(
        studentID: Kv.auth.currentUsername!,
        from: DateTime(2010),
        to: DateTime.now(),
        onLocalQuery: (result) {
          if (!mounted) return;
          setState(() => records = result);
        },
      );
      if (!mounted) return;
      setState(() {});
    });
    super.initState();
  }
}
