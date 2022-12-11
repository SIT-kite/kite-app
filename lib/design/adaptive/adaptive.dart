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
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kite/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

part 'env.dart';

typedef OrientAware<T> = T Function(bool isPortrait);
typedef PageBuilder = Widget Function(BuildContext ctx, Key key);

class AdaptivePage {
  final String label;
  final Widget unselectedIcon;
  final Widget selectedIcon;
  final String? tooltip;
  final PageBuilder builder;

  AdaptivePage({
    required this.label,
    this.tooltip,
    required this.unselectedIcon,
    required this.selectedIcon,
    required this.builder,
  });
}

/// Option A:
/// Use WidgetBuilder: Build the page inside of AdaptiveNavi, the GlobalKey is passthrough.
/// Option B:
/// Pass through the widget itself
class AdaptiveNavi extends StatefulWidget {
  final List<AdaptivePage> pages;
  final int defaultIndex;
  final String title;
  final List<Widget>? actions;

  const AdaptiveNavi({
    super.key,
    required this.title,
    required this.pages,
    required this.defaultIndex,
    this.actions,
  });

  @override
  State<AdaptiveNavi> createState() => _AdaptiveNaviState();
}

class _AdaptiveNaviState extends State<AdaptiveNavi> {
  late int _curIndex = widget.defaultIndex;
  late final _pageKeys = List.generate(
    widget.pages.length,
    (index) => GlobalKey(debugLabel: "Page $index"),
  );
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = widget.pages.mapIndexed((index, p) => p.builder(context, _pageKeys[index])).toList();
  }

  @override
  void didUpdateWidget(covariant AdaptiveNavi oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.defaultIndex == oldWidget.defaultIndex, "defaultIndex can't be change");
  }

  @override
  Widget build(BuildContext context) {
    assert(pages.length == widget.pages.length);
    assert(_curIndex >= 0 && _curIndex < pages.length);
    return context.isPortrait ? buildPortrait(context) : buildLandscape(context);
  }

  Widget buildPortrait(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title.text(),
        actions: widget.actions,
      ),
      body: IndexedStack(
        index: _curIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: widget.pages
            .map((p) => BottomNavigationBarItem(
                  label: p.label,
                  icon: p.unselectedIcon,
                  activeIcon: p.selectedIcon,
                  tooltip: p.tooltip,
                ))
            .toList(),
        currentIndex: _curIndex,
        onTap: (newIndex) {
          setState(() => _curIndex = newIndex);
        },
      ),
    );
  }

  Widget buildLandscape(BuildContext ctx) {
    Widget main = Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: <Widget>[
          NavigationRail(
            leading: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: i18n.back,
                onPressed: () {
                  final subpage = _pageKeys[_curIndex].currentState;
                  if (subpage is AdaptivePageProtocol) {
                    final subNavi = (subpage as AdaptivePageProtocol).navigator;
                    if (subNavi != null && subNavi.canPop()) {
                      subNavi.pop();
                      return;
                    }
                  }
                  ctx.navigator.pop();
                },
              ),
              ...?widget.actions
            ].column(),
            selectedIndex: _curIndex,
            groupAlignment: 1.0,
            onDestinationSelected: (newIndex) {
              setState(() {
                _curIndex = newIndex;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: widget.pages
                .map(
                  (p) => NavigationRailDestination(
                    icon: p.unselectedIcon,
                    selectedIcon: p.selectedIcon,
                    label: p.label.text(),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),

          AdaptiveUI(
              isSubpage: true,
              child: IndexedStack(
                index: _curIndex,
                children: pages,
              )).expanded()
          // This is the main content.
        ],
      ),
    );
    main = WillPopScope(
        child: main,
        onWillPop: () async {
          final subpage = _pageKeys[_curIndex].currentState;
          if (subpage is AdaptivePageProtocol) {
            final subNavi = (subpage as AdaptivePageProtocol).navigator;
            if (subNavi != null && subNavi.canPop()) {
              subNavi.pop();
              return false;
            }
          }
          return true;
        });
    return main;
  }
}
