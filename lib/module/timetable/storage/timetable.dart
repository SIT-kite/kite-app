import 'package:ikite/ikite.dart';
import 'package:kite/module/timetable/storage/course.dart';

import '../entity/course.dart';
import '../entity/entity.dart';
import '../using.dart';

class _K {
  static const timetablesNs = "/timetables";
  static const timetableIds = "/timetableIds";
  static const currentTimetableId = "/currentTimetableId";
  static const lastDisplayMode = "/lastDisplayMode";

  // TODO: Remove this and add a new personalization system.
  static const useOldSchoolPalette = "/useOldSchoolPalette";

  static String makeTimetableKey(String id) => "$timetablesNs/$id";
}

class TimetableStorage {
  final Box<dynamic> box;

  TimetableStorage(this.box);

  DisplayMode? get lastDisplayMode => DisplayMode.at(box.get(_K.lastDisplayMode));

  set lastDisplayMode(DisplayMode? newValue) => box.put(_K.lastDisplayMode, newValue?.index);

  List<String>? get timetableIds => box.get(_K.timetableIds);

  set timetableIds(List<String>? newValue) => box.put(_K.timetableIds, newValue);

  SitTimetable? getSitTimetableBy({required String id}) =>
      iKite.restoreByExactType<SitTimetable>(box.get(_K.makeTimetableKey(id)));

  void setSitTimetable(SitTimetable? timetable, {required String byId}) =>
      box.put(_K.makeTimetableKey(byId), iKite.parseToJson(timetable));

  String? get currentTimetableId => box.get(_K.currentTimetableId);

  set currentTimetableId(String? newValue) => box.put(_K.currentTimetableId, newValue);

  set useOldSchoolColors(bool? newV) => box.put(_K.useOldSchoolPalette, newV);

  bool? get useOldSchoolColors => box.get(_K.useOldSchoolPalette);
}

extension TimetableStorageEx on TimetableStorage {
  bool get hasAnyTimetable => timetableIds?.isNotEmpty ?? false;
}
