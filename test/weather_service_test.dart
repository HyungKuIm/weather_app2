import 'package:weather_app2/models/weather_service.dart';
void main() async {
  final WeatherService weatherService = WeatherService();
  Future<List<dynamic>> weatherFuture;

  weatherFuture = weatherService.fetchWeeklyWeather('seoul'); // 서울 좌표

  await weatherFuture.then((list) {
    for (dynamic weather in list) {
      print('temp: ${weather['main']['temp']}');
    }
  });
}