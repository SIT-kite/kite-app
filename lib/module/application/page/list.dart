import 'package:auto_animated/auto_animated.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/function.dart';
import '../init.dart';
import '../user_widget/application.dart';
import '../using.dart';

// 本科生常用功能列表
const Set<String> _commonUse = <String>{
  '121',
  '011',
  '047',
  '123',
  '124',
  '024',
  '125',
  '165',
  '075',
  '202',
  '023',
  '067',
  '059'
};

class ApplicationList extends StatefulWidget {
  const ApplicationList({Key? key}) : super(key: key);

  @override
  State<ApplicationList> createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> {
  bool enableFilter = false;

  // in descending order
  List<ApplicationMeta> _allDescending = [];
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _fetchMetaList().then((value) {
      if (!mounted) return;
      value.sortBy<num>((e) => -e.count); // descending
      setState(() {
        _allDescending = value;
        _lastError = null;
      });
    }).onError((error, stackTrace) {
      if (!mounted) return;
      setState(() {
        _lastError = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return context.isPortrait ? buildPortrait(context) : buildLandscape(context);
  }

  Widget buildPortrait(BuildContext context) {
    final lastError = _lastError;
    if (lastError != null) {
      return lastError.text().center();
    } else if (_allDescending.isNotEmpty) {
      return buildListPortrait(_allDescending);
    } else {
      return Placeholders.loading();
    }
  }

  Widget buildBodyPortrait() {
    final lastError = _lastError;
    if (lastError != null) {
      return lastError.text().center();
    } else if (_allDescending.isNotEmpty) {
      return buildListPortrait(_allDescending);
    } else {
      return Placeholders.loading();
    }
  }

  List<Widget> buildApplications(List<ApplicationMeta> all) {
    return all
        .where((element) => !enableFilter || _commonUse.contains(element.id))
        .mapIndexed((i, e) => ApplicationTile(item: e, isHot: i < 3))
        .toList();
  }

  Widget buildListPortrait(List<ApplicationMeta> list) {
    final items = buildApplications(list);
    return LiveList(
      showItemInterval: const Duration(milliseconds: 40),
      itemCount: items.length,
      itemBuilder: (ctx, index, animation) => items[index].aliveWith(animation),
    );
  }

  Widget buildLandscape(BuildContext context) {
    final lastError = _lastError;
    if (lastError != null) {
      return lastError.text().center();
    } else if (_allDescending.isNotEmpty) {
      return buildListLandscape(_allDescending);
    } else {
      return Placeholders.loading();
    }
  }

  Widget buildListLandscape(List<ApplicationMeta> list) {
    final items = buildApplications(list);
    return LayoutBuilder(builder: (ctx, constraints) {
      final count = constraints.maxWidth ~/ 300;
      return LiveGrid(
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
          childAspectRatio: 5,
        ),
        showItemInterval: const Duration(milliseconds: 40),
        itemBuilder: (ctx, index, animation) => items[index].aliveWith(animation),
      );
    });
  }

  PopupMenuButton _buildMenuButton(BuildContext context) {
    final menuButton = PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            onTap: () {
              setState(() {
                enableFilter = !enableFilter;
              });
            },
            child: Row(
              children: [
                // 禁用checkbox自身的点击效果，点击由外部接管
                AbsorbPointer(
                  child: Checkbox(value: enableFilter, onChanged: (bool? value) {}),
                ),
                i18n.applicationFilerInfrequentlyUsed.txt,
              ],
            ),
          ),
        ];
      },
    );
    return menuButton;
  }
}

Future<List<ApplicationMeta>> _fetchMetaList() async {
  if (!ApplicationInit.session.isLogin) {
    final username = Kv.auth.currentUsername!;
    final password = Kv.auth.ssoPassword!;
    await ApplicationInit.session.login(
      username: username,
      password: password,
    );
  }
  return await ApplicationInit.applicationService.selectApplicationByCountDesc();
}
