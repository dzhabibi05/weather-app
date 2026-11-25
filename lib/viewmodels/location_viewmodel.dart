import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../services/local_storage_service.dart';
import '../services/weather_api_service.dart';

enum SearchUiState {
  idle,
  loading,
  success,
  empty,
  error,
}

class LocationViewModel extends ChangeNotifier {
  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  LocationViewModel({
    WeatherApiService? apiService,
    LocalStorageService? storageService,
  })  : _apiService = apiService ?? WeatherApiService(),
        _storageService = storageService ?? LocalStorageService();

  SearchUiState _searchState = SearchUiState.idle;
  SearchUiState get searchState => _searchState;

  List<LocationModel> _searchResults = [];
  List<LocationModel> get searchResults => _searchResults;

  List<LocationModel> _favoriteLocations = [];
  List<LocationModel> get favoriteLocations => _favoriteLocations;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoadingFavorites = false;
  bool get isLoadingFavorites => _isLoadingFavorites;

  Timer? _debounceTimer;

  /// Memuat daftar lokasi favorit dari penyimpanan lokal
  Future<void> loadFavorites() async {
    _isLoadingFavorites = true;
    notifyListeners();

    _favoriteLocations = await _storageService.getFavoriteLocations();

    _isLoadingFavorites = false;
    notifyListeners();
  }

  /// Memeriksa apakah suatu lokasi sudah disimpan ke dalam daftar favorit
  bool isFavorite(LocationModel location) {
    return _favoriteLocations.contains(location);
  }

  /// Menambah atau menghapus lokasi dari daftar favorit secara persisten
  Future<void> toggleFavorite(LocationModel location) async {
    if (isFavorite(location)) {
      _favoriteLocations =
          await _storageService.removeFavoriteLocation(location);
    } else {
      _favoriteLocations = await _storageService.addFavoriteLocation(location);
    }
    notifyListeners();
  }

  /// Menangani perubahan teks pada kolom pencarian dengan jeda debounce 500ms
  void onSearchQueryChanged(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      _searchResults = [];
      _searchState = SearchUiState.idle;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      searchCities(query);
    });
  }

  /// Melakukan HTTP GET request pencarian kota ke Open-Meteo Geocoding API
  Future<void> searchCities([String? overrideQuery]) async {
    _debounceTimer?.cancel();

    final queryToSearch = (overrideQuery ?? _searchQuery).trim();
    _searchQuery = queryToSearch;

    if (queryToSearch.isEmpty) {
      _searchResults = [];
      _searchState = SearchUiState.idle;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _searchState = SearchUiState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _apiService.searchCities(queryToSearch);

      if (results.isEmpty) {
        _searchResults = [];
        _searchState = SearchUiState.empty;
      } else {
        _searchResults = results;
        _searchState = SearchUiState.success;
      }
      _errorMessage = null;
    } on WeatherApiException catch (e) {
      _searchResults = [];
      _errorMessage = e.message;
      _searchState = SearchUiState.error;
    } catch (e) {
      _searchResults = [];
      _errorMessage = 'Gagal melakukan pencarian lokasi. Silakan coba lagi.';
      _searchState = SearchUiState.error;
    }

    notifyListeners();
  }

  /// Menghapus kata kunci pencarian dan kembali menampilkan daftar favorit
  void clearSearch() {
    _debounceTimer?.cancel();
    _searchQuery = '';
    _searchResults = [];
    _errorMessage = null;
    _searchState = SearchUiState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
