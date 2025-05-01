import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '오픈웨더맵 api key';
  //api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}
  final String apiUrl = 'https://api.openweathermap.org/data/2.5/forecast';

  Future<List<dynamic>> fetchWeeklyWeather(String city) async {
    final response = await http.get(Uri.parse(
        '$apiUrl?q=$city&units=metric&appid=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['list']; // 일주일치 daily 데이터
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
