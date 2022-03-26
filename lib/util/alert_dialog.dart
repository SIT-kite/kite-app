import 'package:flutter/material.dart';

/// 显示对话框,对话框关闭后Future结束
Future<int?> showAlertDialog(
  BuildContext context, {
  required String title,
  List<Widget> content = const [],
  List<String>? actionTextList,
  List<Widget>? actionWidgetList,
}) async {
  if ((actionTextList == null && actionWidgetList == null) || (actionTextList != null && actionWidgetList != null)) {
    throw Exception("actionTextList与actionWidgetList参数不可同时传入");
  }

  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Center(child: Text(title)),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: content,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: () {
            if (actionTextList != null) {
              return actionTextList.asMap().entries.map((e) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, e.key);
                    },
                    child: Text(e.value),
                  ),
                );
              }).toList();
            } else {
              return actionWidgetList!.asMap().entries.map((e) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, e.key);
                  },

                  /// 把外部Widget的点击吸收掉
                  child: AbsorbPointer(
                    child: e.value,
                  ),
                );
              }).toList();
            }
          }(),
        ),
      ],
    ),
  );
}
