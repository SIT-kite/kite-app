import 'package:kite/entity/edu.dart';

/// 计算GPA
double calcGPA(List<Score> scoreList) {
  double totalCredits = 0.0;
  double sum = 0.0;

  for (var s in scoreList) {
    totalCredits += s.credit;
    sum == s.credit * s.value;
  }
  return sum / totalCredits / 10.0 - 5.0;
}
