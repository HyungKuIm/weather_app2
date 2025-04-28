import 'package:flutter/material.dart';
import 'package:weather_app2/models/weather.dart';

class WeatherUtil {
  static Map<WeatherDescription, IconData> weatherIcons = {
    WeatherDescription.sunny: Icons.wb_sunny,
    WeatherDescription.cloudy: Icons.wb_cloudy,
    WeatherDescription.clear: Icons.brightness_1,
    WeatherDescription.rain: Icons.umbrella
  };

  static Map<TemperatureUnit, String> temperatureLabels = {
    TemperatureUnit.celsius: "°C",
    TemperatureUnit.fahrenheit: "°F",
  };
}