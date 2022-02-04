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
  static late ConstantRemoteDao contactData;

  /// 初始化其他service
  static void _initOther() {
    bulletin = BulletinService(SessionPool.ssoSession);
    campusCard = CampusCardService(SessionPool.ssoSession);
    expenseRemote = ExpenseRemoteService(SessionPool.ssoSession);
    contactData = ContactRemoteService(SessionPool.ssoSession);
    weather = WeatherService();
  }

  static void init() {
    _initLibrary();
    _initEdu();
    _initOther();
  }
}
