import 'entity.dart';

abstract class BoardDao {
  Future<List<PictureSummary>> getPictureList({int page = 1, int count = 20});
}
