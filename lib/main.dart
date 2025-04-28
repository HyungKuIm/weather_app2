import 'package:flutter/material.dart';
import 'package:weather_app2/page/forecast_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        fontFamily: 'Cabin'
      ),
      home: const ForecastPage(title: '동네예보'),
    );
  }
}



