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
import 'package:universal_platform/universal_platform.dart';
import 'package:vibration/vibration.dart' as vb;

abstract class VibrationProtocol {
  Future<void> emit();
}

abstract class TimedProtocol {
  int get milliseconds;
}

class Vibration implements VibrationProtocol, TimedProtocol {
  @override
  final int milliseconds;
  final int amplitude;

  const Vibration({this.milliseconds = 500, this.amplitude = -1});

  @override
  Future<void> emit() async {
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      if (await vb.Vibration.hasVibrator() ?? false) {
        if (await vb.Vibration.hasCustomVibrationsSupport() ?? false) {
          vb.Vibration.vibrate(duration: milliseconds, amplitude: amplitude);
        } else {
          vb.Vibration.vibrate();
        }
      }
    }
  }

  VibrationProtocol operator +(Wait wait) {
    return CompoundVibration._(timedList: [this, wait]);
  }
}

class Wait implements TimedProtocol {
  @override
  final int milliseconds;

  const Wait({this.milliseconds = 500});
}

class CompoundVibration implements VibrationProtocol {
  final List<TimedProtocol> timedList;

  CompoundVibration._({this.timedList = const []});

  @override
  Future<void> emit() async {
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      if (await vb.Vibration.hasVibrator() ?? false) {
        if (await vb.Vibration.hasCustomVibrationsSupport() ?? false) {
          vb.Vibration.vibrate(pattern: timedList.map((e) => e.milliseconds).toList());
        } else {
          for (int i = 0; i < timedList.length; i++) {
            if (i % 2 == 0) {
              vb.Vibration.vibrate();
            } else {
              await Future.delayed(Duration(milliseconds: timedList[i].milliseconds));
            }
          }
        }
      }
    }
  }

  VibrationProtocol operator +(CompoundVibration other) {
    return CompoundVibration._(timedList: timedList + other.timedList);
  }
}
