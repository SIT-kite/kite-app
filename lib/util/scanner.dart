import 'package:flutter/material.dart';

Future<String?> scan(BuildContext context) async {
  final result = await Navigator.of(context).pushNamed('/scanner');
  return result as String?;
}
