import './remote.dart';

class Transaction {
  static DateTime defaultDateTime = DateTime.utc(0);

  /// The compound of [TransactionRaw.transdate] and [TransactionRaw.transtime].
  DateTime datetime = defaultDateTime;

  /// [TransactionRaw.custid]
  int consumerId = 0;
  TransactionType type = TransactionType.consume;
  int balanceBefore = 0;
  int balanceAfter = 0;
  int deltaAmount = 0;
  String deviceName = "";
  String note = "";
}

enum TransactionType { consume, topUp, subsidy, other }
