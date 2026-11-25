class CurrentWeather {
  final double temperature;
  final int relativeHumidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
  final String time;

  const CurrentWeather({
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num).toDouble(),
      relativeHumidity: (json['relative_humidity_2m'] as num).toInt(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      time: (json['time'] as String?) ?? '',
    );
  }
}

class DailyForecast {
  final DateTime date;
  final int weatherCode;
  final double maxTemperature;
  final double minTemperature;
  final int precipitationProbabilityMax;

  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemperature,
    required this.minTemperature,
    required this.precipitationProbabilityMax,
  });
}

class WeatherModel {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeather current;
  final List<DailyForecast> daily;

  const WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.daily,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final currentMap = json['current'] as Map<String, dynamic>;
    final dailyMap = json['daily'] as Map<String, dynamic>;

    final times = (dailyMap['time'] as List<dynamic>? ?? []);
    final codes = (dailyMap['weather_code'] as List<dynamic>? ?? []);
    final maxTemps = (dailyMap['temperature_2m_max'] as List<dynamic>? ?? []);
    final minTemps = (dailyMap['temperature_2m_min'] as List<dynamic>? ?? []);
    final precipProbs =
        (dailyMap['precipitation_probability_max'] as List<dynamic>? ?? []);

    final List<DailyForecast> dailyList = [];
    for (int i = 0; i < times.length; i++) {
      dailyList.add(
        DailyForecast(
          date: DateTime.parse(times[i] as String),
          weatherCode: i < codes.length && codes[i] != null
              ? (codes[i] as num).toInt()
              : 0,
          maxTemperature: i < maxTemps.length && maxTemps[i] != null
              ? (maxTemps[i] as num).toDouble()
              : 0.0,
          minTemperature: i < minTemps.length && minTemps[i] != null
              ? (minTemps[i] as num).toDouble()
              : 0.0,
          precipitationProbabilityMax:
              i < precipProbs.length && precipProbs[i] != null
                  ? (precipProbs[i] as num).toInt()
                  : 0,
        ),
      );
    }

    return WeatherModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: (json['timezone'] as String?) ?? 'auto',
      current: CurrentWeather.fromJson(currentMap),
      daily: dailyList,
    );
  }

  /// Mengambil peluang hujan maksimum hari ini (indeks 0 dari daily forecast)
  int get todayPrecipitationProbability {
    if (daily.isEmpty) return 0;
    return daily.first.precipitationProbabilityMax;
  }
}
