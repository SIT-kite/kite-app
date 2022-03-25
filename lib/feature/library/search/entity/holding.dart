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
class HoldingItem {
  // 图书记录号(同一本书可能有多本，该参数用于标识同一本书的不同本)
  final int bookRecordId;

  // 图书编号(用于标识哪本书)
  final int bookId;

  // 馆藏状态类型名称
  final String stateTypeName;

  // 条码号
  final String barcode;

  // 索书号
  final String callNo;

  // 文献所属馆
  final String originLibrary;

  // 所属馆位置
  final String originLocation;

  // 文献所在馆
  final String currentLibrary;

  // 所在馆位置
  final String currentLocation;

  // 流通类型名称
  final String circulateTypeName;

  // 流通类型描述
  final String circulateTypeDescription;

  // 注册日期
  final DateTime registerDate;

  // 入馆日期
  final DateTime inDate;

  // 单价
  final double singlePrice;

  // 总价
  final double totalPrice;

  const HoldingItem(
      this.bookRecordId,
      this.bookId,
      this.stateTypeName,
      this.barcode,
      this.callNo,
      this.originLibrary,
      this.originLocation,
      this.currentLibrary,
      this.currentLocation,
      this.circulateTypeName,
      this.circulateTypeDescription,
      this.registerDate,
      this.inDate,
      this.singlePrice,
      this.totalPrice);

  @override
  String toString() {
    return 'HoldingItem{bookRecordId: $bookRecordId, bookId: $bookId, stateTypeName: $stateTypeName, barcode: $barcode, callNo: $callNo, originLibrary: $originLibrary, originLocation: $originLocation, currentLibrary: $currentLibrary, currentLocation: $currentLocation, circulateTypeName: $circulateTypeName, circulateTypeDescription: $circulateTypeDescription, registerDate: $registerDate, inDate: $inDate, singlePrice: $singlePrice, totalPrice: $totalPrice}';
  }
}

class HoldingInfo {
  final List<HoldingItem> holdingList;

  const HoldingInfo(this.holdingList);

  @override
  String toString() {
    return 'HoldingInfo{holdingList: $holdingList}';
  }
}
