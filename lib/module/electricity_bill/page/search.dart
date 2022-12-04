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
import 'package:rettulf/rettulf.dart';
import '../using.dart';
import 'dart:math';

class EmptySearchTip extends StatelessWidget {
  final VoidCallback? search;

  const EmptySearchTip({super.key, this.search});

  @override
  Widget build(BuildContext context) {
    return LeavingBlank(icon: Icons.pageview_outlined, desc: i18n.elecBillInitialTip, onIconTap: search);
  }
}

class Search extends StatefulWidget {
  final List<String> searchHistory;
  final VoidCallback? search;
  final void Function(String roomNumber)? onSelected;

  const Search({super.key, required this.searchHistory, this.search, this.onSelected});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return [
      Icons.pageview_outlined.make(size: 120).padAll(20).on(tap: widget.search).expanded(),
      ["Recent Search".text(style: context.textTheme.titleLarge).padAll(10), buildRecentSearch(context).padAll(10)]
          .column()
          .expanded(),
    ].column(maa: MAAlign.spaceAround).center();
  }

  Widget buildRecentSearch(BuildContext ctx) {
    final recent = widget.searchHistory.getRange(0, min(3, widget.searchHistory.length));
    return recent
        .map((e) => e.text(style: ctx.textTheme.headline2).padAll(10).inCard(elevation: 5).onTap(() {
              widget.onSelected?.call(e);
            }))
        .toList()
        .row(maa: MainAxisAlignment.center);
  }
}
