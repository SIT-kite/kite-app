/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';

import '../dao/evaluation.dart';
import '../entity/evaluation.dart';

class CourseEvaluationService extends AService implements CourseEvaluationDao {
  static const _serviceUrl = 'http://jwxt.sit.edu.cn/jwglxt/xspjgl/xspj_cxXspjIndex.html?doType=query&gnmkdm=N401605';

  CourseEvaluationService(ASession session) : super(session);

  List<CourseToEvaluate> _parseEvaluationList(Map<String, dynamic> page) {
    final List evaluationList = page['items'];

    return evaluationList.map((e) => CourseToEvaluate.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CourseToEvaluate>> getEvaluationList() async {
    final Map form = {
      '_search': 'false',
      'queryModel.showCount': 100,
      'queryModel.currentPage': '1',
      'queryModel.sortName': '',
      'queryModel.sortOrder': 'asc',
      'time': 0
    };

    final response = await session.post(_serviceUrl, data: form);
    return _parseEvaluationList(response.data);
  }
}
