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
      highlight: true,
      primary: $Action$(
        text: i18n.submit,
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
        ).padOnly(t:15),
      ].column(mas: MainAxisSize.min).padAll(5),
    );
  }

  @override
  void dispose() {
    super.dispose();
    $captcha.dispose();
  }
}
