import 'package:kite/session/abstract_session.dart';

import 'dao/index.dart';
import 'service/index.dart';

class LibraryInitializer {
  /// 图书信息访问
  static late BookInfoDao bookInfo;

  /// 馆藏信息访问
  static late HoldingInfoDao holdingInfo;

  /// 图书
  static late BookSearchDao bookSearch;

  static late BookImageSearchDao bookImageSearch;

  static late HoldingPreviewDao holdingPreview;

  /// 初始化图书馆相关的service
  static init(ASession session) {
    // 图书馆初始化
    bookInfo = BookInfoService(session);
    holdingInfo = HoldingInfoService(session);
    bookSearch = BookSearchService(session);
    bookImageSearch = BookImageSearchService(session);
    holdingPreview = HoldingPreviewService(session);
  }
}
