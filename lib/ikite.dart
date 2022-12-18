// ignore_for_file: non_constant_identifier_names

import 'package:ikite/ikite.dart';
import 'entities.dart';

void KiteAppDataAdapterPlugin(IKite ikite) {
  ikite.registerAdapter(SitTimetableDataAdapter());
  ikite.registerAdapter(SitTimetableWeekDataAdapter());
  ikite.registerAdapter(SitTimetableDayDataAdapter());
  ikite.registerAdapter(SitTimetableLessonDataAdapter());
  ikite.registerAdapter(SitCourseDataAdapter());
}

void KiteAppDebugPlugin(IKite ikite) {
  ikite.isDebug = true;
  ikite.registerDebugMigration(Migration.of("kite.SitCourse", (from) {
    final res = Map.of(from);
    res["iconName"] ??= "principle";
    if (from.containsKey("weekIndices")) {
      res["rangedWeekNumbers"] ??= from["weekIndices"];
    }
    res["dayIndex"] ??= 0;
    return res;
  }, to: 0));
}
