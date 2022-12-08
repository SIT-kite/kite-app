/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import '../dao/application.dart';
import '../entity/application.dart';
import '../storage/application.dart';

class ApplicationCache extends ApplicationDao {
  final ApplicationDao from;
  final ApplicationStorage to;
  Duration detailExpire;
  Duration listExpire;

  ApplicationCache({
    required this.from,
    required this.to,
    this.detailExpire = const Duration(minutes: 10),
    this.listExpire = const Duration(minutes: 10),
  });

  @override
  Future<List<ApplicationMeta>?> getApplicationMetas() async {
    if (to.box.metas.needRefresh(after: listExpire)) {
      try {
        final res = await from.getApplicationMetas();
        to.setApplicationMetas(res);
        return res;
      } catch (e) {
        return to.getApplicationMetas();
      }
    } else {
      return to.getApplicationMetas();
    }
  }

  @override
  Future<ApplicationDetail?> getApplicationDetail(String applicationId) async {
    final cacheKey = to.box.details.make(applicationId);
    if (cacheKey.needRefresh(after: detailExpire)) {
      try {
        final res = await from.getApplicationDetail(applicationId);
        to.setApplicationDetail(applicationId, res);
        return res;
      } catch (e) {
        return to.getApplicationDetail(applicationId);
      }
    } else {
      return to.getApplicationDetail(applicationId);
    }
  }
}
