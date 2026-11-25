import 'package:flutter/material.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/local_storage_service.dart';
import '../services/weather_api_service.dart';

enum WeatherUiState {
  initial,
  loading,
  success,
  empty,
  error,
}

class WeatherViewModel extends ChangeNotifier {
  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  WeatherViewModel({
    WeatherApiService? apiService,
    LocalStorageService? storageService,
  })  : _apiService = apiService ?? WeatherApiService(),
        _storageService = storageService ?? LocalStorageService();

  WeatherUiState _state = WeatherUiState.initial;
  WeatherUiState get state => _state;

  LocationModel _selectedLocation = LocationModel.defaultLocation();
  LocationModel get selectedLocation => _selectedLocation;

  WeatherModel? _weatherData;
  WeatherModel? get weatherData => _weatherData;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Mengganti mode tampilan antara Terang (Light) dan Gelap (Dark)
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Inisialisasi awal: memuat lokasi terakhir dari SharedPreferences lalu mengambil data cuaca
  Future<void> initWeather() async {
    _state = WeatherUiState.loading;
    notifyListeners();

    _selectedLocation = await _storageService.getLastSelectedLocation();
    await fetchWeather();
  }

  /// Memilih kota baru dari hasil pencarian atau daftar favorit
  Future<void> selectLocation(LocationModel location) async {
    _selectedLocation = location;
    await _storageService.saveLastSelectedLocation(location);
    await fetchWeather();
  }

  /// Mengambil data cuaca terkini & prakiraan harian dari Open-Meteo API
  Future<void> fetchWeather({bool isRefresh = false}) async {
    if (!isRefresh) {
      _state = WeatherUiState.loading;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final result = await _apiService.fetchWeather(
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
      );

      if (result.daily.isEmpty) {
        _weatherData = result;
        _state = WeatherUiState.empty;
      } else {
        _weatherData = result;
        _state = WeatherUiState.success;
      }
      _errorMessage = null;
    } on WeatherApiException catch (e) {
      _errorMessage = e.message;
      _state = WeatherUiState.error;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan tidak terduga saat memuat data cuaca.';
      _state = WeatherUiState.error;
    }

    notifyListeners();
  }

  /// Mencoba ulang pengambilan data ketika terjadi error
  Future<void> retry() async {
    await fetchWeather();
  }
}
