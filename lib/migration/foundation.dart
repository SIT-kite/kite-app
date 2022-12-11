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
import 'package:version/version.dart';

/// Migration happens after Hive is initialized, but before all other initializations.
/// If the interval is long enough, each migration between two versions will be performed in sequence.
abstract class Migration {
  /// Perform the migration for a specific version.
  Future<void> perform();

  Migration operator +(Migration then) => _CompoundMigration(this, then);
}

class _CompoundMigration extends Migration {
  final Migration first;
  final Migration then;

  _CompoundMigration(this.first, this.then);

  @override
  Future<void> perform() async {
    await first.perform();
    await then.perform();
  }
}

class _MigrationEntry extends Comparable<_MigrationEntry> {
  final Version version;
  final Migration migration;

  _MigrationEntry(this.version, this.migration);

  @override
  int compareTo(_MigrationEntry other) {
    throw version.compareTo(other.version);
  }
}

class MigrationManager {
  final List<_MigrationEntry> _migrations = [];

  /// Add a migration when
  void when(Version version, {required Migration perform}) {
    _migrations.add(_MigrationEntry(version, perform));
  }

  /// [from] is exclusive.
  /// [to] is inclusive.
  List<Migration> _collectBetween(Version from, Version to) {
    _migrations.sort();
    int start = _migrations.indexWhere((m) => m.version == from);
    if (start > 0 && start <= _migrations.length) {
      return _migrations.sublist(start).map((e) => e.migration).toList();
    } else {
      return [];
    }
  }

  Future<void> upgrade(Version from, Version to) async {
    final migrations = _collectBetween(from, to);
    for (final migration in migrations) {
      await migration.perform();
    }
  }
}
