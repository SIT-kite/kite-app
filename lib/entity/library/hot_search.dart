class HotSearchItem {
  String hotSearchWord;
  int count;
  HotSearchItem(this.hotSearchWord, this.count);

  @override
  String toString() {
    return 'HotSearchItem{hotSearchWord: $hotSearchWord, count: $count}';
  }
}

class HotSearch {
  List<HotSearchItem> recentMonth = [];
  List<HotSearchItem> totalTime = [];
  HotSearch(this.recentMonth, this.totalTime);

  @override
  String toString() {
    return 'HotSearch{recentMonth: $recentMonth, totalTime: $totalTime}';
  }
}
