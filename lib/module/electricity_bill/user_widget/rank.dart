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

import '../../activity/using.dart';
import '../entity/account.dart';
import 'card.dart';

class RankView extends StatefulWidget {
  const RankView({super.key});

  @override
  RankViewState createState() => RankViewState();
}

class RankViewState extends State<RankView> {
  Rank? curRank;

  @override
  Widget build(BuildContext context) {
    return buildCard(i18n.elecBillRank, _buildRankContent(context));
  }

  Widget _buildRank(BuildContext ctx) {
    final rank = curRank;
    if (rank == null) {
      return Placeholders.loading();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            i18n.elecBill24hBill(rank.consumption.toStringAsFixed(2)),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(i18n.elecBillRankAbove(((1.0 - rank.rank / rank.roomCount) * 100).toStringAsFixed(2)))
        ],
      );
    }
  }

  Widget _buildRankContent(BuildContext ctx) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(children: [
          Icon(
            Icons.stacked_bar_chart,
            size: 100,
            color: context.fgColor,
          ),
          Expanded(child: _buildRank(ctx))
        ]));
  }
}
