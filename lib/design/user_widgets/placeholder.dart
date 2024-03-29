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
import 'package:kite/module/timetable/using.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rettulf/rettulf.dart';

typedef PlaceholderDecorator = Widget Function(Widget);

class Placeholders {
  static Widget loading({
    Key? key,
    double size = 40,
    PlaceholderDecorator? fix,
  }) {
    return _LoadingPlaceholder(
      size: size,
      fix: fix,
    );
  }

  static Widget progress({
    Key? key,
    double size = 40,
    PlaceholderDecorator? fix,
  }) {
    return _ProgressPlaceholder(
      size: size,
      fix: fix,
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  final double size;
  final PlaceholderDecorator? fix;

  const _LoadingPlaceholder({required this.size, this.fix});

  @override
  Widget build(BuildContext context) {
    final trackColor = ProgressIndicatorTheme.of(context).circularTrackColor;
    Widget indicator = LoadingAnimationWidget.inkDrop(color: trackColor ?? context.darkSafeThemeColor, size: size);
    final decorator = fix;
    if (decorator != null) {
      indicator = decorator(indicator);
    }
    return indicator.center();
  }
}

class _ProgressPlaceholder extends StatelessWidget {
  final double size;
  final PlaceholderDecorator? fix;

  const _ProgressPlaceholder({required this.size, this.fix});

  @override
  Widget build(BuildContext context) {
    final trackColor = ProgressIndicatorTheme.of(context).circularTrackColor;
    Widget indicator = LoadingAnimationWidget.beat(color: trackColor ?? context.darkSafeThemeColor, size: size);
    final decorator = fix;
    if (decorator != null) {
      indicator = decorator(indicator);
    }
    return indicator.center();
  }
}

extension LazyLoadingEffectEx<T> on Future<T> {
  Future<T> withDelay(Duration duration) async {
    final res = await this;
    await Future.delayed(duration);
    return res;
  }
}
