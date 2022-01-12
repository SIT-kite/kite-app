import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kite/services/weather.dart';
import 'package:kite/storage/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 计算入学时间, 默认按 9 月 1 日开学来算. 年份 entranceYear 是完整的年份, 如 2018.
int _calcStudyDays(int entranceYear) {
  int days = DateTime.now().difference(DateTime(entranceYear, 9, 1)).inDays;
  return days;
}

class GreetingWidget extends StatefulWidget {
  GreetingWidget({Key? key}) : super(key: key);

  @override
  _GreetingWidgetState createState() => _GreetingWidgetState();
}

class _GreetingWidgetState extends State<GreetingWidget> {
  int studyDays = 1;
  int campus = 1;
  late Weather currentWeather;

  final textStyle = const TextStyle(color: Colors.black54, fontSize: 20);

  @override
  void initState() {
    super.initState();

    // 初始化在校天数
    _getStudyDays().then((value) => setState(() => studyDays = value));
  }

  Future<int> _getStudyDays() async {
    final data = await SharedPreferences.getInstance();
    final studentId = AuthStorage(data).username;

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
    return TextButton(
        onPressed: () => setState(
              () {
                campus = campus == 1 ? 2 : 1;
              },
            ),
        child: SvgPicture.asset('assets/weather/$iconCode.svg', width: 60, height: 60, fit: BoxFit.fill));
  }

  Widget buildAll(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('今天是你在上应大的第 $studyDays 天，', style: textStyle),
            Text('${_getCampusName()}${currentWeather.weather}，${currentWeather.temperature} °C', style: textStyle)
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
      child: FutureBuilder<Weather>(
        future: getCurrentWeather(campus),
        builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
          if (snapshot.hasData) {
            currentWeather = snapshot.data!;
            return buildAll(context);
          }

          return const Text("Loading……");
        },
      ),
    );
  }
}
