import 'package:kite/dao/index.dart';
import 'package:kite/service/library/index.dart';

import 'session_pool.dart';

/// 网络服务请求池
class ServicePool {
  /// 图书信息访问
  static final BookInfoDao bookInfoDao = BookInfoService(SessionPool.librarySession);

  /// 馆藏信息访问
  static final HoldingInfoDao holdingInfoDao = HoldingInfoService(SessionPool.librarySession);

  /// 图书
  static final BookSearchDao bookSearchDao = BookSearchService(SessionPool.librarySession);

  static final BookImageSearchDao bookImageSearchDao = BookImageSearchService(SessionPool.librarySession);

  static final HoldingPreviewDao holdingPreviewDao = HoldingPreviewService(SessionPool.librarySession);
}
