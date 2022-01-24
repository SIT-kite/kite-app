import 'package:kite/dao/index.dart';
import 'package:kite/service/index.dart';

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
  static void _initEdu() {
    courseEvaluation = CourseEvaluationService(SessionPool.eduSession);
    exam = ExamService(SessionPool.eduSession);
    score = ScoreService(SessionPool.eduSession);
    timetable = TimetableService(SessionPool.eduSession);
  }

  static late BulletinDao bulletin;
  static late CampusCardDao campusCard;
  static late ExpenseRemoteDao expenseRemote;
  static late WeatherDao weather;

  /// 初始化其他service
  static void _initOther() {
    bulletin = BulletinService(SessionPool.ssoSession);
    campusCard = CampusCardService(SessionPool.ssoSession);
    expenseRemote = ExpenseRemoteService(SessionPool.ssoSession);
    weather = WeatherService();
  }

  static void init() {
    _initLibrary();
    _initEdu();
    _initOther();
  }
}
