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
import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kite/global/global.dart';
import 'package:kite/home/entity/home.dart';
import 'package:kite/module/activity/using.dart';
import 'package:kite/util/user.dart';
import 'package:kite/util/vibration.dart';

class HomeRearrangePage extends StatefulWidget {
  const HomeRearrangePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeRearrangePageState();
}

class _HomeRearrangePageState extends State<HomeRearrangePage> {
  List<FType> defaultOrder = const [];
  List<FType> homeItemsA = const [];
  List<FType> homeItemsB = const [];
  bool isA = true;

  List<FType> get currentHomeItems => isA ? homeItemsA : homeItemsB;

  set currentHomeItems(List<FType> newList) => isA ? homeItemsA = newList : homeItemsB = newList;
  ValueKey<int> _homeItemsAKey = const ValueKey(1);
  ValueKey<int> _homeItemsBKey = const ValueKey(-1);

  ValueKey<int> get currentKey => isA ? _homeItemsAKey : _homeItemsBKey;

  set currentKey(ValueKey<int> newKey) => isA ? _homeItemsAKey = newKey : _homeItemsBKey = newKey;

  void nextKey() {
    if (isA) {
      currentKey = ValueKey(currentKey.value + 1);
    } else {
      currentKey = ValueKey(currentKey.value - 1);
    }
  }

  @override
  void initState() {
    super.initState();
    defaultOrder = makeDefaultBricks(AccountUtils.getUserType());
    homeItemsA = Kv.home.homeItems ?? makeDefaultBricks(AccountUtils.getUserType());
    homeItemsB = [...homeItemsA];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: i18n.settingsHomepageRearrangeTitle.txt,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: buildResetButton(),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: buildBody(context),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add_outlined),
            onPressed: () {
              setState(() {
                currentHomeItems.insert(0, FType.separator);
                nextKey();
              });
            },
          )),
      onWillPop: () async {
        Global.eventBus.emit(EventNameConstants.onHomeItemReorder);
        return true;
      },
    );
  }

  Widget buildBody(BuildContext ctx) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeScaleTransition(animation: animation, child: child);
        },
        child: buildReorderableList(ctx, currentHomeItems, key: currentKey));
  }

  void _onReorder(List<FType> items, int oldIndex, int newIndex) {
    setState(() {
      // 交换数据
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
    _onSave();
  }

  void _onReorderStart(int index) async {
    await const Vibration(milliseconds: 100).emit();
  }

  void _onReorderEnd(int index) async {
    await const Vibration(milliseconds: 100).emit();
  }

  void _onSave() {
    Kv.home.homeItems = currentHomeItems;
  }

  Widget buildResetButton() {
    return IconButton(
      icon: const Icon(Icons.replay),
      onPressed: () async {
        if (!listEquals(currentHomeItems, defaultOrder)) {
          final confirm = await context.showRequest(
              title: i18n.settingsHomepageRearrangeResetRequestTitle,
              desc: i18n.settingsHomepageRearrangeResetRequest,
              yes: i18n.yes,
              no: i18n.no);
          if (confirm) {
            setState(() {
              isA = !isA;
              currentHomeItems = [...defaultOrder];
            });
            _onSave();
          }
        }
      },
    );
  }

  Widget buildReorderableList(BuildContext ctx, List<FType> items, {Key? key}) {
    return ReorderableListView(
      key: key,
      onReorder: (oldIndex, newIndex) => _onReorder(items, oldIndex, newIndex),
      onReorderStart: _onReorderStart,
      onReorderEnd: _onReorderEnd,
      proxyDecorator: (child, index, animation) {
        return Container(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: context.fgColor, blurRadius: 8)], borderRadius: BorderRadius.circular(12)),
          child: child,
        );
      },
      children: buildWidgetItems(ctx, items),
    );
  }

  List<Widget> buildWidgetItems(BuildContext ctx, List<FType> homeItems) {
    final List<Widget> listItems = [];
    for (int i = 0; i < homeItems.length; ++i) {
      listItems.add(Card(
        key: Key(i.toString()),
        child: _buildFType(homeItems[i]),
      ));
    }
    return listItems;
  }

  Widget _buildFType(FType type) {
    if (type == FType.separator) {
      return const ListTile(
        title: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Divider(thickness: 12),
        ),
      );
    } else {
      return ListTile(
        trailing: const Icon(Icons.menu),
        title: Text(
          type.localized(),
        ),
      );
    }
  }
}
