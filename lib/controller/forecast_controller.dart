import 'package:weather_app2/models/weather.dart';
import 'dart:math' as math;

import '../models/weather_service.dart';

class ForecastController {
  final String _city;
  late Forecast forecast;
  late Weather nowWeather;
  // var _random = math.Random();



  ForecastController(this._city);



  Future<void> init() async {

    //final descriptions = WeatherDescription.values;

    final weatherService = WeatherService();
    final rawList = await weatherService.fetchWeeklyWeather(this._city);

    Map<String, List<dynamic>> groupedByDate = {};

    for (var item in rawList) {
      DateTime dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String dateKey = "${dt.year}-${twoDigits(dt.month)}-${twoDigits(dt.day)}";
      groupedByDate.putIfAbsent(dateKey, () => []).add(item);
    }

    DateTime now = DateTime.now();
    List<ForecastDay> sevenDaysForecast = [];

    groupedByDate.forEach((dateStr, items) {
      List<Weather> forecasts = [];
      double minTemp = double.infinity;
      double maxTemp = double.negativeInfinity;

      for (var item in items) {
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        double temp = (item['main']['temp'] as num).toDouble();
        double min = (item['main']['temp_min']  as num).toDouble();
        double max = (item['main']['temp_max'] as num).toDouble();
        String desc = item['weather'][0]['main'].toString();
        String icon = item['weather'][0]['icon'];


        // enum 매핑 처리
        WeatherDescription description = WeatherDescription.clear;
        if (desc.contains("cloud")) {
          description = WeatherDescription.cloudy;
        } else if (desc.contains("rain")) {
          description = WeatherDescription.rain;
        } else if (desc.contains("clear")) {
          description = WeatherDescription.clear;
        } else if (desc.contains("thunder")) {
          description = WeatherDescription.thunder;
        }
        
        forecasts.add(Weather(city: _city, dateTime: dt, temperature: Temperature(current: temp.round()),
            weatherDescription: description, weatherIcon: icon));

        minTemp = math.min(minTemp, min);
        maxTemp = math.max(maxTemp, max);
      }

      final parsedDate = DateTime.parse(dateStr);
      sevenDaysForecast.add(ForecastDay(
        hourlyWeather: forecasts,
        date: parsedDate,
        min: minTemp.round(),
        max: maxTemp.round(),
      ));

    });


    sevenDaysForecast.sort((a, b) => a.date.compareTo(b.date));
    forecast = Forecast(city: _city, days: sevenDaysForecast);
    ForecastDay nowDay = forecast.days[0];
    nowWeather = ForecastDay.getWeatherForHour(nowDay, now.hour);
  }
}