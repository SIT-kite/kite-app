import 'package:flutter/material.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/user_widget/my_switcher.dart';
import 'package:kite/util/dsl.dart';

class ReminderDialog extends StatefulWidget {
  const ReminderDialog({Key? key}) : super(key: key);

  @override
  State<ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  final ValueNotifier<TimeOfDay?> _notifier =
      ValueNotifier(Kv.report.time == null ? null : TimeOfDay.fromDateTime(Kv.report.time!));

  @override
  Widget build(BuildContext context) {
    final reportTime = Kv.report.time;
    if (reportTime != null) {
      _notifier.value = TimeOfDay(hour: reportTime.hour, minute: reportTime.minute);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        i18n.reportTempReminderDesc.txt,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            i18n.reportTempReminderSwitch.txt,
            MySwitcher(
              Kv.report.enable ?? false,
              onChanged: (value) {
                Kv.report.enable = value;
                setState(() {}); // Notify UI update
              },
            ),
          ],
        ),
        if (Kv.report.enable ?? false)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              i18n.reportTempRemindTime.txt,
              TextButton(
                onPressed: () async {
                  final selectTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(reportTime ?? DateTime.now()),
                  );
                  if (selectTime == null) return;
                  _notifier.value = selectTime;
                  Kv.report.time = DateTime(0, 0, 0, selectTime.hour, selectTime.minute);
                },
                child: ValueListenableBuilder<TimeOfDay?>(
                  valueListenable: _notifier,
                  builder: (context, data, widget) {
                    if (data == null) {
                      return const TimeOfDay(hour: 0, minute: 0).format(context).txt;
                    }
                    return data.format(context).txt;
                  },
                ),
              ),
            ],
          )
      ],
    );
  }
}
