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

class RangeIterator<T extends num> implements Iterator<T> {
  Range range;
  num _current;

  RangeIterator(this.range) : _current = range.start;

  @override
  T get current => (_current - range.step) as T;

  @override
  bool moveNext() {
    if (range.end == null) {
      _current += range.step;
      return true;
    }
    if (_current < range.end!) {
      _current += range.step;
      return true;
    }
    return false;
  }
}

class Range<T extends num> extends Iterable<T> {
  T start;
  num? end;
  num step;

  Range(this.start, this.end, this.step);

  @override
  Iterator<T> get iterator => RangeIterator<T>(this);
}

Range<T> range<T extends num>(T arg1, [
  num? arg2,
  num? arg3,
]) {
  if (arg2 == null) {
    // 有一个参数，arg1代表长度
    return Range((arg1 is int ? 0 : 0.0) as T, arg1, 1);
  } else if (arg3 == null) {
    // 有两个参数
    return Range(arg1, arg2, 1);
  } else {
    // 有三个参数
    return Range(arg1, arg2, arg3);
  }
}
