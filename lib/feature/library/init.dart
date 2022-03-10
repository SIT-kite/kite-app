import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'dao/index.dart';
import 'entity/search_history.dart';
import 'service/index.dart';
import 'storage/search_history.dart';

class LibraryInitializer {
  /// 图书信息访问
  static late BookInfoDao bookInfo;

  /// 馆藏信息访问
  static late HoldingInfoDao holdingInfo;

  /// 图书
  static late BookSearchDao bookSearch;

  static late BookImageSearchDao bookImageSearch;

  static late HoldingPreviewDao holdingPreview;

  static late SearchHistoryDao librarySearchHistory;

  static late HotSearchDao hotSearchService;

  static late LibrarySession session;

  /// 初始化图书馆相关的service
  static Future<void> init({
    required Dio dio,
    required Box<LibrarySearchHistoryItem> searchHistoryBox,
  }) async {
    // 图书馆初始化

    session = LibrarySession(dio);
    bookInfo = BookInfoService(session);
    holdingInfo = HoldingInfoService(session);
    bookSearch = BookSearchService(session);
    bookImageSearch = BookImageSearchService(session);
    holdingPreview = HoldingPreviewService(session);
    hotSearchService = HotSearchService(session);

    librarySearchHistory = SearchHistoryStorage(searchHistoryBox);
  }
}
