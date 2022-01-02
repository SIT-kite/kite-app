import 'package:json_annotation/json_annotation.dart';

part 'holding.g.dart';

/// 图书的流通类型
@JsonSerializable()
class CirculateType {
  // 流通类型代码
  @JsonKey(name: 'cirtype')
  final String circulateType;

  // 图书馆代码(SITLIB等)
  @JsonKey(name: 'libcode')
  final String libraryCode;

  // 流通类型名
  final String name;

  // 流通类型描述
  @JsonKey(name: 'descripe')
  final String description;

  // 不知道是啥
  final int loanNumSign;

  // 不知道是啥
  final int isPreviService;

  const CirculateType(this.circulateType, this.libraryCode, this.name,
      this.description, this.loanNumSign, this.isPreviService);
  factory CirculateType.fromJson(Map<String, dynamic> json) =>
      _$CirculateTypeFromJson(json);
  Map<String, dynamic> toJson() => _$CirculateTypeToJson(this);
}

@JsonSerializable()
class HoldState {
  final int stateType;
  final String stateName;

  const HoldState(this.stateType, this.stateName);

  factory HoldState.fromJson(Map<String, dynamic> json) =>
      _$HoldStateFromJson(json);
  Map<String, dynamic> toJson() => _$HoldStateToJson(this);
}

@JsonSerializable()
class HoldingItem {
  // 图书记录号(同一本书可能有多本，该参数用于标识同一本书的不同本)
  @JsonKey(name: 'recno')
  final int bookRecordId;

  // 图书编号(用于标识哪本书)
  @JsonKey(name: 'bookrecno')
  final int bookId;

  // 馆藏状态类型号
  @JsonKey(name: 'state')
  final int stateType;

  // 条码号
  final String barcode;

  // 索书号
  @JsonKey(name: 'callno')
  final String callNo;

  // 文献所属馆
  @JsonKey(name: 'orglib')
  final String originLibraryCode;
  @JsonKey(name: 'orglocal')
  final String originLocationCode;

  // 文献所在馆
  @JsonKey(name: 'curlib')
  final String currentLibraryCode;
  @JsonKey(name: 'curlocal')
  final String currentLocationCode;

  // 流通类型
  @JsonKey(name: 'cirtype')
  final String circulateType;

  // 注册日期
  @JsonKey(name: 'regdate')
  final String registerDate;

  // String? register_time;

  // 入馆日期
  @JsonKey(name: 'indate')
  final String inDate;

  // 单价
  final double singlePrice;

  // 总价
  final double totalPrice;

  const HoldingItem(
      this.bookRecordId,
      this.bookId,
      this.stateType,
      this.barcode,
      this.callNo,
      this.originLibraryCode,
      this.originLocationCode,
      this.currentLibraryCode,
      this.currentLocationCode,
      this.circulateType,
      this.registerDate,
      this.inDate,
      this.singlePrice,
      this.totalPrice);
// double totalLoanNum;
  factory HoldingItem.fromJson(Map<String, dynamic> json) =>
      _$HoldingItemFromJson(json);
  Map<String, dynamic> toJson() => _$HoldingItemToJson(this);
}

@JsonSerializable()
class BookHoldingInfo {
  // 馆藏信息列表
  final List<HoldingItem> holdingList;

  // "libcodeMap": {
  //     "SITLIB": "上应大",
  //     "999": "中心馆"
  // },

  // 图书馆代码字典
  @JsonKey(name: 'libcodeMap')
  final Map<String, String> libraryCodeMap;

  // "localMap": {
  //   "110": "徐汇社科阅览室",
  //   "111": "徐汇综合阅览室",
  //   "001": "奉贤借阅",
  //   "002": "社科历史地理",
  //   "003": "奉贤外文",

  @JsonKey(name: 'localMap')
  final Map<String, String> locationMap;

  // "pBCtypeMap": {
  //   "SIT_US01": {
  //       "cirtype": "SIT_US01",
  //       "libcode": "SITLIB",
  //       "name": "西文图书",
  //       "descripe": "全局西文图书",
  //       "loanNumSign": 0,
  //       "isPreviService": 1
  //   },
  //   "SIT_US02": {
  //       "cirtype": "SIT_US02",
  @JsonKey(name: 'pBCtypeMap')
  final Map<String, CirculateType> circulateTypeMap;

  // "holdStateMap": {
  //   "32": {
  //       "stateType": 32,
  //       "stateName": "已签收"
  //   },
  //   "0": {
  //       "stateType": 0,
  //       "stateName": "流通还回上架中"
  //   },
  // 馆藏状态
  final Map<String, HoldState> holdStateMap;

  // 不知道是啥
  // "libcodeDeferDateMap": {
  //     "SITLIB": 7,
  //     "999": 7
  // }
  final Map<String, int> libcodeDeferDateMap;

  // 不知道是啥
  // "barcodeLocationUrlMap": {
  //     "SITLIB": "http://210.35.66.106:8088/TSDW/GotoFlash.aspx?szBarCode=",
  //     "999": "http://210.35.66.106:8088"
  // },
  final Map<String, String> barcodeLocationUrlMap;

  const BookHoldingInfo(
      this.holdingList,
      this.libraryCodeMap,
      this.locationMap,
      this.circulateTypeMap,
      this.holdStateMap,
      this.libcodeDeferDateMap,
      this.barcodeLocationUrlMap);

  factory BookHoldingInfo.fromJson(Map<String, dynamic> json) =>
      _$BookHoldingInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BookHoldingInfoToJson(this);
}

class Holding {}
