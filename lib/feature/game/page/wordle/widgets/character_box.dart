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

/*
 * 代码来源：
 * https://github.com/nimone/wordle
 * 版权归原作者所有.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CharacterBox extends StatelessWidget {
  final Color color;
  final Widget? child;

  const CharacterBox({
    Key? key,
    this.child,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.all(4),
      child: child,
    );
  }
}

class CharacterInput extends StatelessWidget {
  final String? value;
  final Function(String) onChange;
  final Function() onSubmit;

  const CharacterInput({
    Key? key,
    this.value = "",
    required this.onChange,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 32),
      autofocus: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 3.0),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 2),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
      ],
      showCursor: false,
      enableInteractiveSelection: false,
      textCapitalization: TextCapitalization.characters,
      onChanged: onChange,
      onFieldSubmitted: (value) => onSubmit(),
    );
  }
}
