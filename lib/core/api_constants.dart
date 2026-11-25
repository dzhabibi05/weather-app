class ApiConstants {
  ApiConstants._();

  // Base URLs Open-Meteo
  static const String geocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';
  static const String weatherBaseUrl = 'https://api.open-meteo.com/v1/forecast';

  // Parameter wajib Weather Forecast API
  static const String currentVariables =
      'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m';
  static const String dailyVariables =
      'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max';
  static const String defaultTimezone = 'auto';

  // SharedPreferences Keys
  static const String favoriteLocationsKey = 'favorite_locations_v1';
  static const String lastSelectedLocationKey = 'last_selected_location_v1';

  // Lokasi Default (Purwokerto, Jawa Tengah)
  static const String defaultCityName = 'Purwokerto';
  static const String defaultAdmin1 = 'Jawa Tengah';
  static const String defaultCountry = 'Indonesia';
  static const double defaultLatitude = -7.4244;
  static const double defaultLongitude = 109.2302;
}
