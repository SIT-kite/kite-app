import 'package:flutter/material.dart';
import 'package:kite/entity/expense.dart';

Widget buildIcon(ExpenseType type, BuildContext context) {
  late final IconData icon;

  switch (type) {
    case ExpenseType.canteen:
      icon = Icons.food_bank_outlined;
      break;
    case ExpenseType.coffee:
      icon = Icons.coffee_rounded;
      break;
    case ExpenseType.shower:
      icon = Icons.shower_outlined;
      break;
    case ExpenseType.store:
      icon = Icons.storefront;
      break;
    case ExpenseType.water:
      icon = Icons.water_damage_outlined;
      break;
    case ExpenseType.unknown:
      icon = Icons.home;
      break;
  }
  return Icon(icon, size: 30, color: Theme.of(context).primaryColor);
}
