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
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kite/design/user_widgets/multiplatform.dart';
import 'package:kite/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

class CaptchaBox extends StatefulWidget {
  final Uint8List captchaData;

  const CaptchaBox({
    super.key,
    required this.captchaData,
  });

  @override
  State<CaptchaBox> createState() => _CaptchaBoxState();
}

class _CaptchaBoxState extends State<CaptchaBox> {
  final $captcha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return $Dialog$(
      title: i18n.captcha,
      primary: $Action$(
        text: i18n.submit,
        warning: true,
        isDefault: true,
        onPressed: () {
          context.navigator.pop($captcha.text);
        },
      ),
      secondary: $Action$(
        text: i18n.cancel,
        onPressed: () {
          context.navigator.pop(null);
        },
      ),
      make: (ctx) => [
        Image.memory(
          widget.captchaData,
          scale: 0.5,
        ),
        $TextField$(
          controller: $captcha,
          placeholder: i18n.enterCaptchaHint,
          prefixIcon: const Icon(Icons.image_search_rounded),
        ).padOnly(t: 15),
      ].column(mas: MainAxisSize.min).padAll(5),
    );
  }

  @override
  void dispose() {
    super.dispose();
    $captcha.dispose();
  }
}
