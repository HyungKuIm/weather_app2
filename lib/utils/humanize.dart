import 'package:weather_app2/models/weather.dart';
import 'package:weather_app2/utils/weather_utils.dart';

import 'DateUtils.dart' as dt;

class Humanize {

  static String currentTemperature(TemperatureUnit unit, Weather temp) {
    var tempInt = temp.temperature.current;
    if (unit == TemperatureUnit.fahrenheit) {
      tempInt = Temperature.celsiusToFahrenheit(temp.temperature.current);
    }
    return '$tempInt ${WeatherUtil.temperatureLabels[unit]}';
  }

  //날씨 정보 취득
  static String weatherDescription(Weather weather) {
    // 요일 취득
    var day = dt.DateUtils.weekdays[weather.dateTime.weekday];
    var description = Weather.displayValues[weather.weatherDescription];
    return "$day, $description";

  }
}
