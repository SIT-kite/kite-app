import 'entity.dart';

abstract class FreshmanDao {
  Future<FreshmanInfo> getInfo();
  Future<void> update({Contact? contact, bool? visible});
  Future<Contact> getContact();
  Future<List<Mate>> getRoommates();
  Future<List<Familiar>> getFamiliars();
  Future<List<Mate>> getClassmates();
  Future<Analysis> getAnalysis();
  Future<void> postAnalysisLog();
}
