// ignore_for_file: non_constant_identifier_names

import 'package:ikite/ikite.dart';
import 'entities.dart';
void KiteAppDataAdapterPlugin(IKite ikite){
  ikite.registerAdapter(SitTimetableDataAdapter());
  ikite.registerAdapter(SitTimetableWeekDataAdapter());
  ikite.registerAdapter(SitTimetableDayDataAdapter());
  ikite.registerAdapter(SitTimetableLessonDataAdapter());
  ikite.registerAdapter(SitCourseDataAdapter());
}