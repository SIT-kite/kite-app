/// The analysis of expense tracker is [here](https://github.com/SIT-kite/expense-tracker).

class DatapackRaw {
  int retcode = 0;
  int retcount = 0;
  List<TransactionRaw> retdata = [];
  String retmsg = "";
}

class TransactionRaw {
  /// example: "20221102"
  /// transaction data
  /// format: yyyymmdd
  String transdate = "";

  /// transaction time
  /// example: "114745"
  /// format: hhmmss
  String transtime = "";

  /// customer id
  /// example: 11045158
  int custid = 0;

  /// card before balance
  /// example: 100
  int transflag = 0;

  /// card after balance
  /// example: 76
  int cardbefbal = 0;

  /// device name
  /// example: "奉贤一食堂一楼汇多pos4（新）", "多媒体-3-4号楼", "上海应用技术学院"
  String? devicename = "";

  /// transaction name
  /// example: "pos消费", "支付宝充值", "补助领取", "批量销户" or "卡冻结", "下发补助" or "补助撤销"
  String transname = "";
}
