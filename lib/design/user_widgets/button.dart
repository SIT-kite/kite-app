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

class PlainExtendedButton extends StatelessWidget {
  final Widget label;
  final Widget? icon;
  final Object? hero;
  final VoidCallback? tap;

  const PlainExtendedButton({super.key, this.hero, required this.label, this.icon, this.tap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: hero,
      icon: icon,
      backgroundColor: Colors.transparent,
      hoverColor: Colors.transparent,
      elevation: 0,
      highlightElevation: 0,
      label: label,
      onPressed: tap,
    );
  }
}

class PlainButton extends StatelessWidget {
  final Widget? label;
  final Widget? child;
  final Object? hero;
  final VoidCallback? tap;

  const PlainButton({super.key, this.hero, this.label, this.child, this.tap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: hero,
      backgroundColor: Colors.transparent,
      hoverColor: Colors.transparent,
      elevation: 0,
      highlightElevation: 0,
      onPressed: tap,
      child: child,
    );
  }
}

// ignore: non_constant_identifier_names
Widget AnimatedSlideDown({
  required bool upWhen,
  required Widget child,
}) {
  const duration = Duration(milliseconds: 300);
  return AnimatedSlide(
    duration: duration,
    offset: upWhen ? Offset.zero : const Offset(0, 2),
    child: AnimatedOpacity(
      duration: duration,
      opacity: upWhen ? 1 : 0,
      child: child,
    ),
  );
}
