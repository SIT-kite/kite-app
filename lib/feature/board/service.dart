import 'package:kite/feature/board/entity.dart';

import '../../abstract/abstract_service.dart';
import '../../abstract/abstract_session.dart';
import 'dao.dart';

class BoardService extends AService implements BoardDao {
  static const _boardUrl = "/board";

  BoardService(ASession session) : super(session);

  @override
  Future<List<PictureSummary>> getPictureList(
      {int page = 1, int count = 20}) async {
    final response = await session.get(_boardUrl);
    final List pictureList = response.data;

    List<PictureSummary> result =
        pictureList.map((e) => PictureSummary.fromJson(e)).toList();
    return result;
  }
}
