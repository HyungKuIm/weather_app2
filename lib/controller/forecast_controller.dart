import 'package:weather_app2/models/weather.dart';
import 'dart:math' as math;

class ForecastController {
  final String _city;
  late Forecast forecast;
  late Weather nowWeather;
  var _random = math.Random();

  ForecastController(this._city) {
    init();
  }

  init() {
    DateTime now = DateTime.now();
    List<ForecastDay> sevenDaysForecast = [];
    final descriptions = WeatherDescription.values;

    List.generate(7, (index) {
      List<Weather> forecasts = [];
      DateTime startDateTime = DateTime(now.year, now.month, now.day, 0);

      for (var i = 0; i < 8; i++) {
        var description = descriptions.elementAt(
          _random.nextInt(descriptions.length));
        forecasts.add(Weather(city: _city, dateTime: startDateTime,
            temperature: Temperature(current: 25),
            weatherDescription: description, weatherIcon: ""));
        startDateTime = startDateTime.add(Duration(hours: 3));

      }
      int low = 15;
      int high = 35;
      int runningMin = 100;
      int runningMax = -100;
      final temp = low + _random.nextInt(high - low);
      runningMin = math.min(runningMin, temp) - 5;
      runningMax = math.max(runningMax, temp);

      final forecastDay = ForecastDay(hourlyWeather: forecasts, date: now,
          min: runningMin, max: runningMax);
      sevenDaysForecast.add(forecastDay);
      now = now.add(Duration(days: 1));

    });
    forecast = Forecast(city: _city, days: sevenDaysForecast);
    ForecastDay nowDay = forecast.days[0];
    nowWeather = ForecastDay.getWeatherForHour(nowDay, now.hour);

  }
}