import 'package:kite/dao/index.dart';
import 'package:kite/service/edu/evaluation.dart';
import 'package:kite/service/edu/index.dart';
import 'package:kite/service/library/index.dart';

import 'session_pool.dart';

/// 网络服务请求池
class ServicePool {
  /// 图书信息访问
  static late BookInfoDao bookInfo;

  /// 馆藏信息访问
  static late HoldingInfoDao holdingInfo;

  /// 图书
  static late BookSearchDao bookSearch;

  static late BookImageSearchDao bookImageSearch;

  static late HoldingPreviewDao holdingPreview;

  /// 初始化图书馆相关的service
  static _initLibrary() {
    // 图书馆初始化
    bookInfo = BookInfoService(SessionPool.librarySession);
    holdingInfo = HoldingInfoService(SessionPool.librarySession);
    bookSearch = BookSearchService(SessionPool.librarySession);
    bookImageSearch = BookImageSearchService(SessionPool.librarySession);
    holdingPreview = HoldingPreviewService(SessionPool.librarySession);
  }

  static late CourseEvaluationDao courseEvaluation;
  static late ExamDao exam;
  static late ScoreDao score;
  static late TimetableDao timetable;

  /// 初始化教务相关的service
  static _initEdu() {
    courseEvaluation = CourseEvaluationService(SessionPool.eduSession);
    exam = ExamService(SessionPool.eduSession);
    score = ScoreService(SessionPool.eduSession);
    timetable = TimetableService(SessionPool.eduSession);
  }

  static void init() {
    _initLibrary();
    _initEdu();
    // TODO 还有更多的初始化
  }
}
