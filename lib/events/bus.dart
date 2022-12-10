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
import 'package:event_bus/event_bus.dart';

final _homepage = EventBus();
final _global = EventBus();
final _expenseTracker = EventBus();

class On {
  static void home<T>(void Function(T event)? onFire) {
    _homepage.on<T>().listen(onFire);
  }

  static void global<T>(void Function(T event)? onFire) {
    _global.on<T>().listen(onFire);
  }

  static void expenseTracker<T>(void Function(T event) onFire) {
    _expenseTracker.on<T>().listen(onFire);
  }
}

class FireOn {
  static void homepage<T>(T event) {
    _homepage.fire(event);
  }

  static void global<T>(T event) {
    _global.fire(event);
  }

  static void expenseTracker<T>(T event) {
    _homepage.fire(event);
  }
}
