import 'package:kite/dao/index.dart';
import 'package:kite/service/library/index.dart';

import 'session_pool.dart';

/// 网络服务请求池
class ServicePool {
  /// 图书信息访问
  static final BookInfoDao bookInfo = BookInfoService(SessionPool.librarySession);

  /// 馆藏信息访问
  static final HoldingInfoDao holdingInfo = HoldingInfoService(SessionPool.librarySession);

  /// 图书
  static final BookSearchDao bookSearch = BookSearchService(SessionPool.librarySession);

  static final BookImageSearchDao bookImageSearch = BookImageSearchService(SessionPool.librarySession);

  static final HoldingPreviewDao holdingPreview = HoldingPreviewService(SessionPool.librarySession);
}
