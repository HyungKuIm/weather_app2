import 'package:weather_app2/models/weather.dart';
import 'dart:math' as math;

import '../models/weather_service.dart';

class ForecastController {
  final String _city;
  late Forecast forecast;
  late Weather nowWeather;
  var _random = math.Random();

  final WeatherService _weatherService = WeatherService();
  late Future<List<dynamic>> weatherFuture;

  ForecastController(this._city) {
    init();
  }



  Future<void> init() async {

    //final descriptions = WeatherDescription.values;

    final weatherService = WeatherService();
    final rawList = await weatherService.fetchWeeklyWeather(this._city);

    Map<String, List<dynamic>> groupedByDate = {};

    for (var item in rawList) {
      DateTime dt = DateTime.fromMicrosecondsSinceEpoch(item['dt'] * 1000);
      String dateKey = "${dt.year}-${dt.month}-${dt.day}";
      groupedByDate.putIfAbsent(dateKey, () => []).add(item);
    }

    DateTime now = DateTime.now();
    List<ForecastDay> sevenDaysForecast = [];

    groupedByDate.forEach((dateStr, items) {
      List<Weather> forecasts = [];
      double minTemp = double.infinity;
      double maxTemp = double.negativeInfinity;

      for (var item in items) {
        DateTime dt = DateTime.fromMicrosecondsSinceEpoch(item['dt'] * 1000);
        double temp = item['main']['temp'];
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
        
        forecasts.add(Weather(city: _city, dateTime: dt, temperature: Temperature(current: temp.toInt()),
            weatherDescription: description, weatherIcon: icon));

        minTemp = math.min(minTemp, temp);
        maxTemp = math.max(maxTemp, temp);
      }

      final parsedDate = DateTime.parse(dateStr);
      sevenDaysForecast.add(ForecastDay(
        hourlyWeather: forecasts,
        date: parsedDate,
        min: minTemp.toInt(),
        max: maxTemp.toInt(),
      ));

    });

    // List.generate(5, (index) {
    //   List<Weather> forecasts = [];
    //   DateTime startDateTime = DateTime(now.year, now.month, now.day, 0);
    //
    //   for (var i = 0; i < 8; i++) {
    //     var description = descriptions.elementAt(
    //       _random.nextInt(descriptions.length));
    //     forecasts.add(Weather(city: _city, dateTime: startDateTime,
    //         temperature: Temperature(current: 25),
    //         weatherDescription: description, weatherIcon: ""));
    //     startDateTime = startDateTime.add(Duration(hours: 3));
    //
    //   }
    //   int low = 15;
    //   int high = 35;
    //   int runningMin = 100;
    //   int runningMax = -100;
    //   final temp = low + _random.nextInt(high - low);
    //   runningMin = math.min(runningMin, temp) - 5;
    //   runningMax = math.max(runningMax, temp);
    //
    //   final forecastDay = ForecastDay(hourlyWeather: forecasts, date: now,
    //       min: runningMin, max: runningMax);
    //   sevenDaysForecast.add(forecastDay);
    //   now = now.add(Duration(days: 1));
    //
    // });
    // forecast = Forecast(city: _city, days: sevenDaysForecast);
    // ForecastDay nowDay = forecast.days[0];
    // nowWeather = ForecastDay.getWeatherForHour(nowDay, now.hour);
    // 정렬 및 오늘 날짜 찾기
    sevenDaysForecast.sort((a, b) => a.date.compareTo(b.date));
    forecast = Forecast(city: _city, days: sevenDaysForecast);
    ForecastDay nowDay = forecast.days[0];
    nowWeather = ForecastDay.getWeatherForHour(nowDay, now.hour);
  }
}