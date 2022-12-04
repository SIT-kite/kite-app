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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../cache.dart';
import '../using.dart';

import '../dao/Freshman.dart';
import '../entity/info.dart';
import '../entity/statistics.dart';
import '../init.dart';

class FreshmanStatisticsPage extends StatelessWidget {
  const FreshmanStatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FreshmanDao freshmanDao = FreshmanInit.freshmanDao;
    final FreshmanCacheManager freshmanCacheManager = FreshmanInit.freshmanCacheManager;
    return Scaffold(
      body: MyFutureBuilder<List<dynamic>>(
        futureGetter: () => Future.wait([freshmanDao.getAnalysis(), freshmanDao.getInfo()]),
        enablePullRefresh: true,
        onPreRefresh: () async {
          freshmanCacheManager.clearAnalysis();
          freshmanCacheManager.clearBasicInfo();
        },
        builder: (context, data) {
          return _buildBodyStack(context, data[0], data[1]);
        },
      ),
    );
  }

  /// 分享图风格分析
  Widget _buildBodyStack(BuildContext context, Analysis data, FreshmanInfo info) {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.pinkAccent.withAlpha(10)]))),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 120.h,
            ),
          ],
        ),
        Positioned(
            top: 300.h, left: MediaQuery.of(context).size.width / 4, child: buildTextColumn(context, data, info)),
        Align(
            alignment: const Alignment(0, -0.9),
            child: Image.asset(
              'assets/freshman/welcome_bg.png',
              width: 350,
              height: 350,
            )),
        Positioned(
          left: 30.w,
          top: 30.h,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: SvgPicture.asset(
              'assets/home/kite.svg',
              width: 70,
              height: 70,
            ),
          ),
        ),
      ],
    );
  }

  // TODO: I18n
  /// 文字列抽离
  Widget buildTextColumn(BuildContext context, Analysis data, FreshmanInfo info) {
    TextStyle italicText = const TextStyle(fontStyle: FontStyle.italic, fontSize: 15);
    // TODO: I18n
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row(text: '终于等到你 ', n: info.name),
        _row(text: '欢迎来到上海应用技术大学'),
        SizedBox(height: 15.h),
        _row(text: '有 ', n: data.collegeCount.toString(), text2: '人和你一起'),
        _row(text: '来到了 ', n: info.college),
        _row(text: '你的专业共有 ', n: data.major.total.toString(), text2: '人'),
        Row(
          children: [
            _row(text: '其中男生', n: data.major.boys.toString(), text2: '人，'),
            _row(text: '女生', n: data.major.girls.toString(), text2: '人'),
          ],
        ),
        SizedBox(height: 15.h),
        if (data.sameCity > 0) _row(text: '还有 ', n: data.sameCity.toString(), text2: '人和你来自同一座城市'),
        if (data.sameHighSchool > 0) _row(text: '其他 ', n: data.sameHighSchool.toString(), text2: '人是你的高中校友'),
        if (data.sameHighSchool > 0 || data.sameCity > 0) _row(text: '有时间可以认识一下哦'),
        SizedBox(height: 15.h),
        if (data.sameName > 0) _row(text: '哦，还有', n: data.sameName.toString(), text2: '人和你同名'),
        if (data.sameName > 0) _row(text: '也许会在某一不期而遇'),
        SizedBox(height: 20.h),
        _row(text: '生活是一种绵延不绝的渴望,', style: italicText),
        _row(text: '渴望不断上升，', style: italicText),
        _row(text: '变得更伟大而高贵。', style: italicText),
        _row(text: '--杜伽尔', style: italicText),
      ],
    );
  }

  /// 文字行抽离
  Widget _row({
    required String text,
    String? n,
    String? text2,
    TextStyle? style,
    double fontSize = 18,
  }) {
    return Row(
      children: [
        Text(
          text,
          style: style ?? TextStyle(fontSize: fontSize),
        ),
        if (![null, ''].contains(n))
          Text(
            n!,
            style: TextStyle(fontSize: fontSize, color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
        if (![null, ''].contains(text2))
          Text(
            text2!,
            style: TextStyle(fontSize: fontSize),
          )
      ],
    );
  }
}
