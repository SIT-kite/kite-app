import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kite/service/weather.dart';
import 'package:kite/storage/storage_pool.dart';

/// 计算入学时间, 默认按 9 月 1 日开学来算. 年份 entranceYear 是完整的年份, 如 2018.
int _calcStudyDays(int entranceYear) {
  int days = DateTime.now().difference(DateTime(entranceYear, 9, 1)).inDays;
  return days;
}

class GreetingWidget extends StatelessWidget {
  int studyDays = 1;
  int campus = 1;
  final Weather currentWeather;
  final textStyle = const TextStyle(color: Colors.white70, fontSize: 20);

  GreetingWidget(this.currentWeather, {Key? key}) : super(key: key);

  Future<int> _getStudyDays() async {
    final studentId = StoragePool.authSetting.currentUsername!;

    if (studentId.isNotEmpty) {
      int entranceYear = 2000 + int.parse(studentId.substring(0, 2));
      return _calcStudyDays(entranceYear);
    }
    return 1;
  }

  String _getCampusName() {
    if (campus == 1) return "奉贤校区";
    return "徐汇校区";
  }

  Widget _buildWeatherIcon(String iconCode) {
    return SvgPicture.asset('assets/weather/$iconCode.svg',
        width: 60, height: 60, fit: BoxFit.fill, color: Colors.white);
  }

  Widget buildAll(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('今天是你在上应大的第 $studyDays 天', style: textStyle),
            Text('${_getCampusName()}${currentWeather.weather}  ${currentWeather.temperature} °C', style: textStyle)
          ],
        ),
        SizedBox(child: _buildWeatherIcon(currentWeather.icon)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: FutureBuilder<int>(
        future: _getStudyDays(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            studyDays = snapshot.data!;
            return Container(padding: const EdgeInsets.only(left: 12, right: 12), child: buildAll(context));
          }

          return const Text("Loading……");
        },
      ),
    );
  }
}
