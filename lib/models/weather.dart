// 기상예보(일주일)
class Forecast {
  final String city;
  final List<ForecastDay> days;

  Forecast({required this.city, required this.days});
}

// 기생예보
class ForecastDay {
  final List<Weather> hourlyWeather;
  final DateTime date;
  final int min;
  final int max;

  ForecastDay({required this.hourlyWeather, required this.date,
              required this.min, required this.max});

  static Weather getWeatherForHour(ForecastDay self, int hour) {
    return self.hourlyWeather.firstWhere((w) => w.dateTime.hour <= hour);
  }
}

// 날씨
class Weather {
  final String city;
  final DateTime dateTime;
  final Temperature temperature;
  final WeatherDescription weatherDescription;
  final String weatherIcon;

  Weather({required this.city, required this.dateTime,
            required this.temperature, required this.weatherDescription,
          required this.weatherIcon});

  static Map<WeatherDescription, String> displayValues = {
    WeatherDescription.clear: "선명",
    WeatherDescription.cloudy: "흐림",
    WeatherDescription.rain: "비",
    WeatherDescription.sunny: "맑음"
  };

}

// 온도
class Temperature {
  final int current;
  final TemperatureUnit temperatureUnit;

  static int celsiusToFahrenheit(int temp) => (temp * 9 / 5 + 32).floor();

  Temperature({required this.current, this.temperatureUnit = TemperatureUnit.celsius});
}

// 온도단위
enum TemperatureUnit { celsius, fahrenheit }

// 날씨상세
enum WeatherDescription { clear, cloudy, sunny, rain, snow, thunder }