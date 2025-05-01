import 'package:flutter/material.dart';
import 'package:weather_app2/controller/forecast_controller.dart';
import 'package:weather_app2/models/weather.dart';
import 'package:weather_app2/utils/DateUtils.dart' as dt;
import 'package:weather_app2/utils/weather_utils.dart';
import 'package:weather_app2/utils/humanize.dart';
import 'package:weather_app2/page/city_page.dart';

class ForecastPage extends StatefulWidget {

  final String title;

  const ForecastPage({super.key, required this.title});

  @override
  State<StatefulWidget> createState() {
    return _ForecastPageState();
  }

}


class _ForecastPageState extends State<ForecastPage> {

  ForecastController? _forecastController;
  late Future<void> _initFuture;
  String _city = 'Seoul';

  @override
  void initState() {
    super.initState();
    _loadForecast();
  }

  void _loadForecast() {
    _forecastController = ForecastController(_city);
    _initFuture = _forecastController!.init();
  }

  void _selectCity() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CityPage(selectedCity: _city,))
    );

    if (result != null && result != _city) {
      setState(() {
        _city = result;
        _loadForecast();  // 도시변경후 재검색
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _initFuture, builder: (context, snapshop) {
      if (snapshop.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshop.hasError) {
        return Center(child: Text("에러 발생: ${snapshop.error}"));
      }

      final forecast = _forecastController!.forecast;


      return Scaffold(
        appBar: AppBar(
          title: Text(
              _city,
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineLarge,
            ),
          leading: IconButton(
              onPressed: _selectCity,
              icon: const Icon(Icons.location_city)),
          actions: [
            Center(
              child: Padding(padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        WeatherUtil.temperatureLabels[TemperatureUnit.celsius]!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),),
            )
          ],
          centerTitle: true,),
        
        body:

          Padding(padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Stack(
                children: <Widget>[
                  getWeatherImage(_forecastController!.nowWeather.weatherDescription),
                  Column(
                    verticalDirection: VerticalDirection.up,
                    children: <Widget>[
                      Table(
                        columnWidths: const {
                          0: FixedColumnWidth(100.0),
                          2: FixedColumnWidth(30.0),
                          3: FixedColumnWidth(30.0)
                        },
                        children: forecast.days.map((day) {
                          Weather dailyWeather = day.hourlyWeather[0];
                          final iconUrl = "http://openweathermap.org/img/wn/${dailyWeather.weatherIcon}@2x.png";
                          return TableRow(
                            children: [
                            TableCell(child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                dt.DateUtils.weekdays[dailyWeather.dateTime
                                .weekday]!),)),
                            TableCell(child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.network(iconUrl, width: 32, height: 32))),
                            TableCell(child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(day.max.toString()))),
                            TableCell(child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(day.min.toString()))),
                          ]
                          );
                        }).toList(),

                      ),
                    ]
                  ),

                  Padding(padding: EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                            Humanize.weatherDescription(
                                _forecastController!.nowWeather),
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineLarge),
                        Text(
                            Humanize.currentTemperature(
                                TemperatureUnit.celsius,
                                _forecastController!.nowWeather)
                            ,
                            style: Theme
                                .of(context)
                                .textTheme
                                .displayLarge),
                      ],
                    ),
                  )
                ],
              )
          )
        //),
        //})

      );
    });
  }


}

Widget getWeatherImage(WeatherDescription description) {
  switch (description) {
    case WeatherDescription.clear:
      return Positioned(
        left: 50, top: 50,
        child: Image.asset('assets/images/sun.png', width: 150, height: 150),
      );
    case WeatherDescription.cloudy:
      return Positioned(
        left: 50, top: 120,
        child: Image.asset('assets/images/cloud.png', width: 200, height: 100),
      );
    case WeatherDescription.rain:
      return Stack(
        children: [
          Positioned(
            left: 50, top: 120,
            child: Image.asset('assets/images/cloud.png', width: 200, height: 100),
          ),
          Positioned(
            left: 100, top: 200,
            child: Image.asset('assets/images/rain.png', width: 100, height: 100),
          ),
        ],
      );
    case WeatherDescription.snow:
      return Positioned(
        left: 50, top: 120,
        child: Image.asset('assets/images/snow.png', width: 200, height: 100),
      );
    case WeatherDescription.thunder:
      return Stack(
        children: [
          Positioned(
            left: 50, top: 50,
            child: Image.asset('assets/images/cloud.png', width: 200, height: 100),
          ),
          Positioned(
            left: 100, top: 150,
            child: Image.asset('assets/images/thunder.png', width: 100, height: 100),
          ),
        ],
      );
    default:
      return Positioned(
        left: 50, top: 50,
        child: Image.asset('assets/images/cloud.png', width: 150, height: 150),
      );
  }
}
