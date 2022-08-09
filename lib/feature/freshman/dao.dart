import 'entity.dart';

abstract class FreshmanDao {
  Future<FreshmanInfo> getInfo();
  Future<void> update({Contact? contact, bool? visible});
  Future<List<Roommate>> getRoommates();
  Future<List<Familiar>> getFamiliars();
  Future<List<Classmate>> getClassmates();
  Future<Analysis> getAnalysis();
  Future<void> postAnalysisLog();
}
