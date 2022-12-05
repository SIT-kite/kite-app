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
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rettulf/rettulf.dart';

import '../init.dart';
import '../user_widget/connected.dart';
import '../user_widget/disconnected.dart';
import '../user_widget/quick_button.dart';
import '../using.dart';

class NetworkToolPage extends StatefulWidget {
  const NetworkToolPage({Key? key}) : super(key: key);

  @override
  State<NetworkToolPage> createState() => _NetworkToolPageState();
}

const iconDir = "assets/connectivity";
const unavailableIconPath = "$iconDir/unavailable.svg";
const availableIconPath = "$iconDir/available.svg";

class _NetworkToolPageState extends State<NetworkToolPage> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();

    ConnectivityInit.ssoSession.checkConnectivity().then((value) {
      Log.info('当前是否连接校园网：$value');
      if (!mounted) return;
      setState(() => isConnected = value);
    });
  }

  final _connectedKey = const ValueKey("Connected");
  final _disconnectedKey = const ValueKey("Disconnected");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: i18n.networkTool.text()),
        body: context.isPortrait ? buildPortraitBody(context) : buildLandscapeBody(context));
  }

  Widget buildPortraitBody(BuildContext context) {
    return [
      buildFigure(context).expanded(),
      AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: isConnected
                  ? ConnectedBlock(
                      key: _connectedKey,
                    )
                  : [const DisconnectedBlock(), const QuickButtons()]
                      .column(key: _disconnectedKey, maa: MainAxisAlignment.spaceEvenly))
          .expanded(),
    ].column(caa: CrossAxisAlignment.center, maa: MainAxisAlignment.center).center();
  }

  Widget buildLandscapeBody(BuildContext context) {
    final figure = isConnected
        ? buildFigure(context).center()
        : [buildFigure(context), const QuickButtons().expanded()]
            .column(caa: CrossAxisAlignment.center, maa: MainAxisAlignment.spaceEvenly);
    return [
      figure.expanded(),
      AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: isConnected
                  ? ConnectedBlock(
                      key: _connectedKey,
                    )
                  : DisconnectedBlock(
                      key: _disconnectedKey,
                    ))
          .center()
          .expanded(),
    ].row(caa: CrossAxisAlignment.center, maa: MainAxisAlignment.center).center();
  }

  Widget buildFigure(BuildContext context) {
    final iconPath = isConnected ? availableIconPath : unavailableIconPath;
    return SvgPicture.asset(iconPath, width: 300, height: 300, color: context.darkSafeThemeColor)
        .constrained(const BoxConstraints(minWidth: 120, minHeight: 120, maxWidth: 240, maxHeight: 240));
  }
}
