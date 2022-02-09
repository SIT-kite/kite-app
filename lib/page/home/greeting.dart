/*
 * 上应小风筝(SIT-kite)  便利校园，一步到位
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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kite/entity/weather.dart';
import 'package:kite/global/event_bus.dart';
import 'package:kite/global/storage_pool.dart';

/// 计算入学时间, 默认按 9 月 1 日开学来算. 年份 entranceYear 是完整的年份, 如 2018.
int _calcStudyDays(int entranceYear) {
  int days = DateTime.now().difference(DateTime(entranceYear, 9, 1)).inDays;
  return days;
}

class GreetingWidget extends StatefulWidget {
  const GreetingWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GreetingWidgetState();
}

class _GreetingWidgetState extends State<GreetingWidget> {
  int studyDays = 1;
  int campus = StoragePool.homeSetting.campus;
  Weather currentWeather = StoragePool.homeSetting.lastWeather;

  @override
  void initState() {
    super.initState();
    eventBus.on(EventNameConstants.onWeatherUpdate, _onWeatherUpdate);
  }

  @override
  void deactivate() {
    super.deactivate();
    eventBus.off(EventNameConstants.onWeatherUpdate, _onWeatherUpdate);
  }

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
    return "徐汇";
  }

  Widget _buildWeatherIcon(String iconCode) {
    return SvgPicture.asset('assets/weather/$iconCode.svg',
        width: 60, height: 60, fit: BoxFit.fill, color: Colors.white);
  }

  void _onWeatherUpdate(dynamic newWeather) {
    StoragePool.homeSetting.lastWeather = newWeather;
    campus = StoragePool.homeSetting.campus;

    setState(() => currentWeather = newWeather as Weather);
  }

  Widget buildAll(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline3?.copyWith(color: Colors.white70);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('今天是你在上应大的第 $studyDays 天', style: textStyle),
              Text('${_getCampusName()}${currentWeather.weather}  ${currentWeather.temperature} °C', style: textStyle)
            ],
          ),
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
            return Container(padding: EdgeInsets.only(left: 12.w, right: 12.w), child: buildAll(context));
          }

          return const Text("Loading……");
        },
      ),
    );
  }
}
