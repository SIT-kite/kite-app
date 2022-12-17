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
import 'dart:math';
import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:kite/entities.dart';
import 'package:kite/hive/type_id.dart';
import 'package:kite/l10n/extension.dart';

part 'school.g.dart';

@HiveType(typeId: HiveTypeId.semester)
enum Semester {
  @HiveField(0)
  all,
  @HiveField(1)
  firstTerm,
  @HiveField(2)
  secondTerm;

  String localized() {
    switch (this) {
      case Semester.all:
        return i18n.fullAcademicYear;
      case Semester.firstTerm:
        return i18n.semester1st;
      case Semester.secondTerm:
        return i18n.semester2rd;
    }
  }
}

@HiveType(typeId: HiveTypeId.schoolYear)
class SchoolYear {
  static const all = SchoolYear(null);
  @HiveField(0)
  final int? year;

  const SchoolYear(this.year);

  @override
  String toString() {
    return (year ?? '').toString();
  }
}

String semesterToFormField(Semester semester) {
  const mapping = {
    Semester.all: '',
    Semester.firstTerm: '3',
    Semester.secondTerm: '12',
  };
  return mapping[semester]!;
}

Semester formFieldToSemester(String s) {
  Map<String, Semester> semester = {
    '': Semester.all,
    '3': Semester.firstTerm,
    '12': Semester.secondTerm,
  };
  return semester[s]!;
}

SchoolYear formFieldToSchoolYear(String s) {
  final year = int.parse(s.split('-')[0]);
  return SchoolYear(year);
}

String schoolYearToFormField(SchoolYear y) {
  if (y.year != null) {
    return '${y.year!}-${y.year! + 1}';
  }
  return '';
}

double stringToDouble(String s) => double.tryParse(s) ?? double.nan;

class CourseCategory {
  static const Map<String, List<String>> _courseToCategory = {
    'art': [
      '手绘',
      '速写',
      '插图',
      '图文',
      '创作',
      '摄影',
      '构图',
      '美术',
      '水彩',
      '油画',
      '素描',
      '艺术',
      '雕塑',
      '装饰',
      '写生',
      '技法',
      '视觉',
      '漆艺',
      'UI',
      '广告',
      '美学'
    ],
    'biological': ['生物', '环境', '花卉', '药物', '微生物', '材料'],
    'history': ['文化', '历史', '设计史', '书画', '文明史'],
    'building': ['建筑', '轨道', '铁道', '桥梁', '结构力学', '房屋', '建材', '工程', '混凝土', '建设'],
    'chemical': ['化学', '传热学', '仪器', '药剂', '腐蚀', '制药', '化妆品', '酒', '香精', '聚合物', '水质', '药理'],
    'engineering': ['测量', '力学', '光谱', '检测', '有限单元'],
    'practice': ['实习', '实训', '营销', '就业', '实践', '职业'],
    'circuit': ['电工', '电磁', '电子', '信号', '数码', '数字', '嵌入式', 'EDA', '单片机'],
    'computer': [
      'Python',
      '计算机',
      '程序设计',
      '软件',
      'web',
      '开发',
      '建模',
      '非线性编辑',
      '微机',
      '图形',
      '操作系统',
      '数据结构',
      'C语言',
      '编译',
      '人工智能'
    ],
    'control': ['控制', '半导体', '泵', '电源', '系统', '故障诊断', '接触网', '维修', '液压', '气压', '汽轮机'],
    'experiment': ['特效', '会展', '实验', '活性剂', '光学'],
    'electricity': ['化工', '给水', '燃烧', '管网', '热工', '玻璃', '固废', '发电厂'],
    'music': ['音频', ', ' '音乐', ', ' '产品设计'],
    'social': ['园林'],
    'geography': ['生态', '一带一路', '大气污染', '地理'],
    'economic': ['估价', '贸易', '会计', '经济', '货币'],
    'physical': ['土壤', '国际', '物理'],
    'design': ['规划', '园艺', '线造型', '制图', '设计', 'Design', 'CAD'],
    'mechanical': ['工艺', '设备', '装备', '机械', '机电', '金属', '钢'],
    'sports': ['篮球'],
    'internship': ['香原料', '美容', '品评', '社区', '心理', '采编', '招聘', '妇女'],
    'political': ['珠宝'],
    'running': ['体育'],
    'language': ['英语', '德语', '语言', '法语', '日语', '英文', '英汉', '专业外语'],
    'ideological': ['思想道德', '毛泽东', '法治', '近现代史', '马克思', '政策', '政治'],
    'reading': ['植物', '信息论'],
    'management': ['食品', '管理', '项目', '关系', '安全', '行为', '社会'],
    'training': ['通信', '网络', '物联网', '文献检索'],
    'business': ['多媒体', '动画', '审计', '企业'],
    'statistical': ['数据分析', '数据挖掘', '数据库', '大数据', '市场', '调研', '证券', '统计'],
    'mathematics': ['计算', '复变函数', '概率论', '积分', '数学', '代数'],
    'technology': ['空调', '技术', '科学', '科技'],
    'generality': ['书籍'],
    'literature': ['文学', '编辑', '新闻', '报刊'],
    'curriculum': ['论文'],
  };

  static String query(String curriculum) {
    for (var title in _courseToCategory.keys) {
      for (var item in _courseToCategory[title]!) {
        if (curriculum.contains(item)) {
          return title;
        }
      }
    }
    return 'principle';
  }
}

final List<String> weekWord = ['一', '二', '三', '四', '五', '六', '日'];

const List<Color> colorList = [
  Color.fromARGB(178, 251, 83, 82),
  Color.fromARGB(153, 115, 123, 250),
  Color.fromARGB(178, 116, 185, 255),
  Color.fromARGB(178, 118, 126, 253),
  Color.fromARGB(178, 245, 175, 77),
  Color.fromARGB(178, 187, 137, 106),
  Color.fromARGB(178, 232, 67, 147),
  Color.fromARGB(178, 188, 140, 240),
  Color.fromARGB(178, 116, 185, 255)
];

class Timepoint {
  /// 小时
  final int hour;

  /// 分
  final int minute;

  const Timepoint(this.hour, this.minute);

  @override
  String toString() => '$hour:${'$minute'.padLeft(2, '0')}';

  TimeDuration operator -(Timepoint b) => TimeDuration.fromMinutes(totalMinutes - b.totalMinutes);

  int get totalMinutes => hour * 60 + minute;
}

class TimeDuration {
  final int hour;
  final int minute;

  int get totalMinutes => hour * 60 + minute;

  const TimeDuration(this.hour, this.minute);

  const TimeDuration.fromMinutes(int minutes)
      : hour = minutes ~/ 60,
        minute = minutes % 60;

  String localized() {
    final h = "$hour";
    final min = "$minute".padLeft(2, '0');
    if (hour == 0) {
      return i18n.minuteF(min);
    } else if (minute == 0) {
      return i18n.hourF(h);
    }
    return i18n.hourMinuteF(h, min);
  }
}

class SchoolTimetable {
  /// 上课时间
  final Timepoint classBegin;

  /// 下课时间
  final Timepoint classOver;

  const SchoolTimetable(this.classBegin, this.classOver);
}

const fengxianCampusTimetable = [
  // 上午
  SchoolTimetable(Timepoint(8, 20), Timepoint(9, 05)),
  SchoolTimetable(Timepoint(9, 10), Timepoint(9, 55)),
  SchoolTimetable(Timepoint(10, 15), Timepoint(11, 00)),
  SchoolTimetable(Timepoint(11, 05), Timepoint(11, 50)),
  // 下午
  SchoolTimetable(Timepoint(13, 00), Timepoint(13, 45)),
  SchoolTimetable(Timepoint(13, 50), Timepoint(14, 35)),
  SchoolTimetable(Timepoint(14, 55), Timepoint(15, 40)),
  SchoolTimetable(Timepoint(15, 45), Timepoint(16, 30)),
  // 晚上
  SchoolTimetable(Timepoint(18, 00), Timepoint(18, 45)),
  SchoolTimetable(Timepoint(18, 50), Timepoint(19, 35)),
  SchoolTimetable(Timepoint(19, 40), Timepoint(20, 25)),
];

const building1Timetable = [
  // 上午
  SchoolTimetable(Timepoint(8, 20), Timepoint(9, 05)),
  SchoolTimetable(Timepoint(9, 10), Timepoint(9, 55)),
  SchoolTimetable(Timepoint(10, 25), Timepoint(11, 10)),
  SchoolTimetable(Timepoint(11, 15), Timepoint(12, 00)),
  // 下午
  SchoolTimetable(Timepoint(13, 00), Timepoint(13, 45)),
  SchoolTimetable(Timepoint(13, 50), Timepoint(14, 35)),
  SchoolTimetable(Timepoint(14, 55), Timepoint(15, 40)),
  SchoolTimetable(Timepoint(15, 45), Timepoint(16, 30)),
  // 晚上
  SchoolTimetable(Timepoint(18, 00), Timepoint(18, 45)),
  SchoolTimetable(Timepoint(18, 50), Timepoint(19, 35)),
  SchoolTimetable(Timepoint(19, 40), Timepoint(20, 25)),
];

const building2Timetable = [
  // 上午 （3-4不下课）
  SchoolTimetable(Timepoint(8, 20), Timepoint(9, 05)),
  SchoolTimetable(Timepoint(9, 10), Timepoint(9, 55)),
  SchoolTimetable(Timepoint(10, 15), Timepoint(11, 00)),
  SchoolTimetable(Timepoint(11, 00), Timepoint(11, 45)),
  // 下午
  SchoolTimetable(Timepoint(13, 00), Timepoint(13, 45)),
  SchoolTimetable(Timepoint(13, 50), Timepoint(14, 35)),
  SchoolTimetable(Timepoint(14, 55), Timepoint(15, 40)),
  SchoolTimetable(Timepoint(15, 45), Timepoint(16, 30)),
  // 晚上
  SchoolTimetable(Timepoint(18, 00), Timepoint(18, 45)),
  SchoolTimetable(Timepoint(18, 50), Timepoint(19, 35)),
  SchoolTimetable(Timepoint(19, 40), Timepoint(20, 25)),
];

const xuhuiTimetable = [
  // 上午
  SchoolTimetable(Timepoint(8, 00), Timepoint(8, 45)),
  SchoolTimetable(Timepoint(8, 50), Timepoint(9, 35)),
  SchoolTimetable(Timepoint(9, 55), Timepoint(10, 40)),
  SchoolTimetable(Timepoint(10, 45), Timepoint(11, 30)),
  // 下午
  SchoolTimetable(Timepoint(13, 00), Timepoint(13, 45)),
  SchoolTimetable(Timepoint(13, 50), Timepoint(14, 35)),
  SchoolTimetable(Timepoint(14, 55), Timepoint(15, 40)),
  SchoolTimetable(Timepoint(15, 45), Timepoint(16, 30)),
  // 晚上
  SchoolTimetable(Timepoint(18, 00), Timepoint(18, 45)),
  SchoolTimetable(Timepoint(18, 50), Timepoint(19, 35)),
  SchoolTimetable(Timepoint(19, 40), Timepoint(20, 25)),
];

/// 解析 timeIndex, 得到第一节小课的序号. 如给出 1~4, 返回 1
int getIndexStart(int index) {
  int i = 0;
  while (index & 1 == 0) {
    i++;
    index >>= 1;
  }
  return i;
}

/// 解析 timeIndex, 得到最后一节小课的序号. 如给出 1~4, 返回 4
int getIndexEnd(int start, int index) {
  int i = start;
  index >>= start + 1;
  while (index & 1 != 0) {
    i++;
    index >>= 1;
  }
  return i;
}

List<SchoolTimetable> getBuildingTimetable(String campus, String place) {
  if (campus.contains('徐汇')) {
    return xuhuiTimetable;
  }
  if (place.startsWith('一教')) {
    return building1Timetable;
  } else if (place.startsWith('二教')) {
    return building2Timetable;
  }
  return fengxianCampusTimetable;
}

/// 将 "第几周、周几" 转换为日期. 如, 开学日期为 2021-9-1, 那么将第一周周一转换为 2021-9-1
DateTime getDateFromWeekDay(DateTime semesterBegin, int week, int day) {
  return semesterBegin.add(Duration(days: (week - 1) * 7 + day - 1));
}

/// 将 timeIndex 转换为对应的字符串
///
/// ss: 开始时间
/// ee: 结束时间
/// SS: 开始的节次
/// EE: 结束的节次
String formatTimeIndex(List<SchoolTimetable> timetable, int timeIndex, String format) {
  final indexStart = getIndexStart(timeIndex);
  final indexEnd = getIndexEnd(indexStart, timeIndex);
  final timeStart = timetable[indexStart - 1].classBegin;
  final timeEnd = timetable[indexEnd - 1].classOver;

  return format
      .replaceAll('ss', timeStart.toString())
      .replaceAll('ee', timeEnd.toString())
      .replaceAll('SS', indexStart.toString())
      .replaceAll('EE', indexEnd.toString());
}

/// 将 timeIndex 转换为对应的字符串
///
/// ss: 开始时间
/// ee: 结束时间
/// SS: 开始的节次
/// EE: 结束的节次
String formatTimeslotIndex(List<SchoolTimetable> timetable, SitTimetableLesson lesson, String format) {
  final timeStart = timetable[lesson.startIndex].classBegin;
  final timeEnd = timetable[lesson.endIndex].classOver;

  return format
      .replaceAll('ss', timeStart.toString())
      .replaceAll('ee', timeEnd.toString())
      .replaceAll('SS', (lesson.startIndex + 1).toString())
      .replaceAll('EE', (lesson.endIndex + 1).toString());
}

/// 删去 place 括号里的描述信息. 如, 二教F301（机电18中外合作专用）
String formatPlace(String place) {
  int indexOfBucket = place.indexOf('（');
  if (indexOfBucket != -1) {
    return place.substring(0, indexOfBucket);
  }
  indexOfBucket = place.indexOf('(');
  return indexOfBucket != -1 ? place.substring(0, indexOfBucket) : place;
}

extension DateTimeUtil on DateTime {
  DateTime clearTime([int hour = 0, int minute = 0, int second = 0]) {
    return DateTime(year, month, day, hour, minute, second);
  }
}

/// Replace the full-width brackets to ASCII ones
String stylizeCourseName(String name) {
  return name.replaceAll("（", "(").replaceAll("）", ")");
}

Duration calcuSwitchAnimationDuration(num distance) {
  final time = sqrt(max(1, distance) * 100000);
  return Duration(milliseconds: time.toInt());
}
