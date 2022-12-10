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
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kite/credential/symbol.dart';
import 'package:kite/module/shared/entity/weather.dart';
import 'package:kite/module/simple_page/page/weather.dart';
import 'package:kite/global/global.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/storage/init.dart';

class GreetingWidget extends StatefulWidget {
  const GreetingWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GreetingWidgetState();
}

class _GreetingWidgetState extends State<GreetingWidget> {
  int? studyDays;
  int campus = Kv.home.campus;
  Weather currentWeather = Kv.home.lastWeather ?? Weather.defaultWeather;

  Timer? dayWatcher;
  DateTime? _admissionDate;

  @override
  void initState() {
    super.initState();
    Global.eventBus.on(EventNameConstants.onWeatherUpdate, _onWeatherUpdate);
    // 如果用户不是新生或老师，那么就显示学习天数
    if (Auth.oaCredential != null && Auth.lastUserType != UserType.teacher) {
      setState(() {
        studyDays = _getStudyDaysAndInitState();
      });
    }

    /// Rebuild the study days when date is changed.
    dayWatcher = Timer.periodic(const Duration(minutes: 1), (timer) {
      final admissionDate = _admissionDate;
      if (admissionDate != null) {
        final now = DateTime.now();
        setState(() {
          studyDays = now.difference(admissionDate).inDays;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    dayWatcher?.cancel();
    Global.eventBus.off(EventNameConstants.onWeatherUpdate, _onWeatherUpdate);
  }

  int _getStudyDaysAndInitState() {
    final oaCredential = Auth.oaCredential;
    if (oaCredential != null) {
      final id = oaCredential.account;

      if (id.isNotEmpty) {
        final admissionYearTrailing = int.tryParse(id.substring(0, 2));
        if (admissionYearTrailing != null) {
          int admissionYear = 2000 + admissionYearTrailing;
          final admissionDate = DateTime(admissionYear, 9, 1);
          _admissionDate = admissionDate;

          /// 计算入学时间, 默认按 9 月 1 日开学来算. 年份 admissionYear 是完整的年份, 如 2018.
          return DateTime.now().difference(admissionDate).inDays;
        }
      }
    }
    return 0;
  }

  String _getCampusName() {
    if (campus == 1) return i18n.fengxianDistrict;
    return i18n.xuhuiDistrict;
  }

  Widget _buildWeatherIcon(String iconCode) {
    return GestureDetector(
      onTap: () {
        final title = i18n.campusWeatherTitle(_getCampusName());
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => WeatherPage(campus, title: title)));
      },
      child: SvgPicture.asset('assets/weather/$iconCode.svg',
          width: 60, height: 60, fit: BoxFit.fill, color: Colors.white),
    );
  }

  void _onWeatherUpdate(dynamic newWeather) {
    Kv.home.lastWeather = newWeather;
    campus = Kv.home.campus;

    setState(() => currentWeather = newWeather as Weather);
  }

  Widget buildAll(BuildContext context) {
    final textStyleSmall = Theme.of(context).textTheme.headline6?.copyWith(
          color: Colors.white60,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        );
    final textStyleLarge = Theme.of(context)
        .textTheme
        .headline6
        ?.copyWith(color: Colors.white70, fontSize: 24.0, fontWeight: FontWeight.w700);
    final textStyleWeather = Theme.of(context).textTheme.subtitle1?.copyWith(
          color: Colors.white70,
          fontSize: 19.0,
          fontWeight: FontWeight.w500,
        );
    final days = studyDays;
    final List<Widget> sitDate;
    if (days == null) {
      sitDate = [
        Text(i18n.greetingHeader0L1, style: textStyleSmall),
      ];
    } else {
      if (days <= 0) {
        sitDate = [
          Text(i18n.greetingHeader0L1, style: textStyleSmall),
          Text(i18n.greetingHeader0L2, style: textStyleLarge),
        ];
      } else {
        sitDate = [
          Text(i18n.greetingHeaderL1, style: textStyleSmall),
          Text(i18n.greetingHeaderL2(yOrNo(i18n.greetingHeaderEnableIncrement) ? days + 1 : days),
              style: textStyleLarge),
        ];
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...sitDate,
              Text('${_getCampusName()} ${currentWeather.weather} ${currentWeather.temperature} °C',
                  style: textStyleWeather)
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
      child: buildAll(context),
    );
  }
}
