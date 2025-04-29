import 'package:flutter/material.dart';
import 'package:weather_app2/controller/forecast_controller.dart';
import 'package:weather_app2/models/weather.dart';
import 'package:weather_app2/utils/DateUtils.dart' as dt;
import 'package:weather_app2/utils/weather_utils.dart';
import 'package:weather_app2/utils/humanize.dart';

class ForecastPage extends StatefulWidget {

  final String title;

  const ForecastPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() {
    return _ForecastPageState();
  }

}


class _ForecastPageState extends State<ForecastPage> {

  late final ForecastController _forecastController;

  @override
  void initState() {
    super.initState();
    _forecastController = ForecastController("Seoul");
  }

  @override
  Widget build(BuildContext context) {

    final forecast = _forecastController.forecast;

    return Scaffold(
      appBar: AppBar(title: Text(
          _forecastController.nowWeather.city,
        style: Theme.of(context).textTheme.headlineLarge,
      ), centerTitle: true,),
      body: Padding(padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Stack(
          children: <Widget>[
            Positioned(
                left: 50.0, top: 50.0,
                child: Image.asset('assets/images/sun.png', width: 150.0, height: 150.0,)),
            Positioned(
                left: 50.0, top: 120.0,
                child: Image.asset('assets/images/cloud.png', width: 200.0, height: 100.0,)),
            Column(
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Table(
                  columnWidths: const {
                    0: FixedColumnWidth(100.0),
                    2: FixedColumnWidth(30.0),
                    3: FixedColumnWidth(30.0)
                  },
                  children: List.generate(5, (index) {
                    ForecastDay day = forecast.days[index];
                    Weather dailyWeather = forecast.days[index].hourlyWeather[0];

                    return TableRow(
                      children: [
                        TableCell(child: Padding(padding: const EdgeInsets.all(4.0),
                          child: Text(dt.DateUtils.weekdays[dailyWeather.dateTime.weekday]!),)),
                        TableCell(child: Padding(padding: const EdgeInsets.all(4.0),
                          child: Icon(WeatherUtil.weatherIcons[dailyWeather.weatherDescription]))),
                        TableCell(child: Padding(padding: const EdgeInsets.all(4.0),
                          child: Text(day.max.toString()))),
                        TableCell(child: Padding(padding: const EdgeInsets.all(4.0),
                            child: Text(day.min.toString()))),
                      ]
                    );

                  }),
                ),
                Padding(padding: EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        Humanize.weatherDescription(_forecastController.nowWeather),
                          style: Theme.of(context).textTheme.headlineLarge),
                      Text(
                        Humanize.currentTemperature(TemperatureUnit.celsius, _forecastController.nowWeather)
                          ,
                          style: Theme.of(context).textTheme.displayLarge),
                    ],
                  ),)
              ],
            )
          ],
        )
      )
    );
  }


}