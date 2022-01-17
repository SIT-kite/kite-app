import 'package:json_annotation/json_annotation.dart';

part 'score.g.dart';

@JsonSerializable()
class Score {
  @JsonKey(name: 'cj', fromJson: _stringToDouble)
  // 成绩
  double value = 0.0;
  @JsonKey(name: 'kcmc')
  // 课程
  String course = "";
  @JsonKey(name: 'kch')
  // 课程代码
  String courseId = "";
  @JsonKey(name: 'jxb_id')
  // 班级
  String classId = "";
  @JsonKey(name: 'xnmmc')
  // 学年
  String schoolYear = "";
  @JsonKey(name: 'xqm', fromJson: _stringToSemester)
  // 学期
  int semester = -1;
  @JsonKey(name: 'xf', fromJson: _stringToDouble)
  // 学分
  double credit = 0.0;

  Score();

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);

  @override
  String toString() {
    return 'Score{score: $value, course: $course, courseId: $courseId, classId: $classId, schoolYear: $schoolYear, semester: $semester, credit: $credit}';
  }

  static int _stringToSemester(String s) {
    Map<String, int> semester = {'': 0, '3': 1, '12': 2, '16': 3};
    return semester[s] ?? -1;
  }

  static double _stringToDouble(String s) => double.tryParse(s) ?? -1.0;
}

class ScoreDetail {
  /// 成绩名称
  final String scoreType;

  /// 占总成绩百分比
  final String percentage;

  /// 成绩数值
  final double value;

  const ScoreDetail({
    this.scoreType = "",
    this.percentage = "",
    this.value = 0.0,
  });
}
