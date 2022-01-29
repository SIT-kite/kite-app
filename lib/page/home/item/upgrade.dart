import 'package:flutter/material.dart';
import 'package:kite/page/home/item.dart';
import 'package:kite/util/upgrade.dart';
import 'package:kite/util/url_launcher.dart';

const String appUpgradeUrl = 'https://kite.sunnysab.cn/upgrade';

class UpgradeItem extends StatelessWidget {
  const UpgradeItem({Key? key}) : super(key: key);

  void onTapUpdate(AppVersion version) {
    final url = '$appUpgradeUrl?type=${version.platform}&oldVersion=${version.version}';
    launchInBrowser(url);
  }

  @override
  Widget build(BuildContext context) {
    final future = getUpdate();

    return FutureBuilder<AppVersion?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          return GestureDetector(
            onTap: () => onTapUpdate(snapshot.data!),
            child: HomeItem(
              title: '更新',
              subtitle: '小风筝有新的版本了，点击更新',
              icon: 'assets/home/icon_upgrade.svg',
            ),
          );
        }
        return const SizedBox(height: 0);
      },
    );
  }
}
