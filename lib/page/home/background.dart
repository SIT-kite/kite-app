import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({Key? key}) : super(key: key);

  Widget _buildWeatherBg(Size windowSize) {
    return WeatherBg(
      weatherType: WeatherType.sunny,
      width: windowSize.width,
      height: windowSize.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;

    return _buildWeatherBg(windowSize);
  }
}
