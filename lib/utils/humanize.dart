import 'package:weather_app2/models/weather.dart';
import 'package:weather_app2/utils/weather_utils.dart';

import 'DateUtils.dart';

class Humanize {

  static String currentTemperature(TemperatureUnit unit, Weather temp) {
    var tempInt = temp.temperature.current;
    if (unit == TemperatureUnit.fahrenheit) {
      tempInt = Temperature.celsiusToFahrenheit(temp.temperature.current);
    }
    return '$tempInt ${WeatherUtil.temperatureLabels[unit]}';
  }
}