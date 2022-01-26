enum UploadResult {
  // 无校徽
  noLogo,
  // 达到最大限制
  maxLimit,
  // 没抽中
  failed,
  // 抽中
  successful,
  // 活动结束
  outdated,
}

class UploadResultModel {
  UploadResult result = UploadResult.noLogo;
  int type = 0;
}

class MyCard {
  int type = 0;
  DateTime ts = DateTime.now();
}

class PraiseResult {
  bool hasResult = false;
  String url = '';
}
