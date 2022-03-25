import 'package:flutter/material.dart';
import 'package:kite/component/multibutton_switch.dart';

class TodayTomorrowSwitch extends StatelessWidget {
  final VoidCallback onSwitchToday;
  final VoidCallback onSwitchTomorrow;

  static const _weekText = '日一二三四五六';

  const TodayTomorrowSwitch({
    Key? key,
    required this.onSwitchToday,
    required this.onSwitchTomorrow,
  }) : super(key: key);

  Widget buildTodayWidget() {
    final DateTime today = DateTime.now();
    final todayWeekText = '周' + _weekText.substring(today.weekday, today.weekday + 1);
    final todayDateText = '${today.month}-${today.day}';
    return Text(
      "$todayWeekText\n"
      "今天($todayDateText)",
      textAlign: TextAlign.center,
    );
  }

  Widget buildTomorrowWidget() {
    final DateTime today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final tomorrowWeekText = '周' + _weekText.substring(tomorrow.weekday, tomorrow.weekday + 1);
    final tomorrowDateText = '${tomorrow.month}-${tomorrow.day}';
    return Text(
      "$tomorrowWeekText\n"
      "明天($tomorrowDateText)",
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiButtonSwitch(
      children: [
        buildTodayWidget(),
        buildTomorrowWidget(),
      ],
      onSwitch: (i) {
        [onSwitchToday, onSwitchTomorrow][i]();
      },
    );
  }
}

class AddAppointment extends StatelessWidget {
  const AddAppointment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加预约'),
      ),
      body: Column(
        children: [
          TodayTomorrowSwitch(
            onSwitchToday: () {},
            onSwitchTomorrow: () {},
          ),
          Expanded(
            child: ListView(),
          ),
        ],
      ),
    );
  }
}
