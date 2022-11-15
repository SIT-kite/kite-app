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

import './remote.dart';
import '../using.dart';
import 'shared.dart';

class Transaction {
  /// The compound of [TransactionRaw.transdate] and [TransactionRaw.transtime].
  DateTime datetime = defaultDateTime;

  /// [TransactionRaw.custid]
  int consumerId = 0;
  TransactionType type = TransactionType.consume;
  double balanceBefore = 0;
  double balanceAfter = 0;
  double deltaAmount = 0;

  bool get isConsume => (balanceAfter - balanceBefore) < 0;
  String deviceName = "";
  String note = "";
}

enum TransactionType {
  consume(Icons.shopping_bag_outlined),
  water(Icons.water_damage_outlined),
  shower(Icons.shower_outlined),
  food(Icons.restaurant),
  store(Icons.store_outlined),
  topUp(Icons.savings),
  subsidy(Icons.handshake_outlined),
  coffee(Icons.coffee_rounded),
  library(Icons.import_contacts_outlined),
  other(Icons.menu_rounded);

  final IconData icon;

  const TransactionType(this.icon);

  String localized() {
    switch (this) {
      case TransactionType.food:
        return i18n.expenseCanteen;
      case TransactionType.coffee:
        return i18n.expenseCafe;
      case TransactionType.water:
        return i18n.expenseHotWater;

      case TransactionType.shower:
        return i18n.expenseShower;

      case TransactionType.store:
        return i18n.expenseGrocery;

      case TransactionType.other:
        return i18n.expenseStuff;
      case TransactionType.consume:
        return "TODO";
      case TransactionType.topUp:
        return "TODO";
      case TransactionType.subsidy:
        return "TODO";
      case TransactionType.library:
        return "TODO";
    }
  }
}
