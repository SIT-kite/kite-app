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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

/// 平台相关的组件封装
///
///
///
///
///
class MyPlatformWidget extends StatelessWidget {
  final WidgetBuilder? desktopOrWebBuilder;
  final WidgetBuilder? desktopBuilder;
  final WidgetBuilder? mobileBuilder;
  final WidgetBuilder? androidBuilder;
  final WidgetBuilder? iosBuilder;
  final WidgetBuilder? linuxBuilder;
  final WidgetBuilder? windowsBuilder;
  final WidgetBuilder? macosBuilder;
  final WidgetBuilder? webBuilder;
  final WidgetBuilder? fuchsiaBuilder;
  final WidgetBuilder? otherBuilder;
  const MyPlatformWidget({
    Key? key,
    this.desktopOrWebBuilder,
    this.desktopBuilder,
    this.mobileBuilder,
    this.androidBuilder,
    this.iosBuilder,
    this.linuxBuilder,
    this.windowsBuilder,
    this.macosBuilder,
    this.webBuilder,
    this.fuchsiaBuilder,
    this.otherBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 按照优先级去调用相应的widget builder
    if (UniversalPlatform.isWindows && windowsBuilder != null) return windowsBuilder!(context);
    if (UniversalPlatform.isMacOS && macosBuilder != null) return macosBuilder!(context);
    if (UniversalPlatform.isLinux && linuxBuilder != null) return linuxBuilder!(context);
    if (UniversalPlatform.isAndroid && androidBuilder != null) return androidBuilder!(context);
    if (UniversalPlatform.isIOS && iosBuilder != null) return iosBuilder!(context);
    if (UniversalPlatform.isWeb && webBuilder != null) return webBuilder!(context);
    if (UniversalPlatform.isFuchsia && fuchsiaBuilder != null) return fuchsiaBuilder!(context);
    if (!UniversalPlatform.isDesktopOrWeb && mobileBuilder != null) return mobileBuilder!(context);
    if (UniversalPlatform.isDesktop && desktopBuilder != null) return desktopBuilder!(context);
    if (UniversalPlatform.isDesktopOrWeb && desktopOrWebBuilder != null) return desktopOrWebBuilder!(context);
    if (otherBuilder != null) return otherBuilder!(context);
    throw UnimplementedError('No platform widget builder: ${Platform.operatingSystem}');
  }
}
