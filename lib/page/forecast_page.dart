import 'package:flutter/material.dart';
import 'package:weather_app2/controller/forecast_controller.dart';
import 'package:weather_app2/models/weather.dart';
import 'package:weather_app2/utils/DateUtils.dart' as dt;
import 'package:weather_app2/utils/weather_utils.dart';

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
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: <Widget>[
          Positioned(
              left: 50.0, top: 50.0,
              child: Image.asset('assets/images/sun.png', width: 150.0,)),
          Positioned(
              // left: 100.0, top: 150.0,
              child: Image.asset('assets/images/cloud.png', width: 200.0,)),
          Column(
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(100.0),
                  2: FixedColumnWidth(30.0),
                  3: FixedColumnWidth(30.0)
                },
                children: List.generate(7, (index) {
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
              )
            ],
          )
        ],
      )
    );
  }


}