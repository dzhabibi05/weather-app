import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_constants.dart';
import '../models/location_model.dart';

class LocalStorageService {
  /// Mengambil daftar lokasi favorit yang tersimpan di SharedPreferences
  Future<List<LocationModel>> getFavoriteLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList =
        prefs.getStringList(ApiConstants.favoriteLocationsKey);

    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }

    return jsonList.map((item) {
      final Map<String, dynamic> map =
          json.decode(item) as Map<String, dynamic>;
      return LocationModel.fromJson(map);
    }).toList();
  }

  /// Menambahkan lokasi ke daftar favorit (mencegah duplikasi)
  Future<List<LocationModel>> addFavoriteLocation(
      LocationModel location) async {
    final currentFavorites = await getFavoriteLocations();

    if (!currentFavorites.contains(location)) {
      currentFavorites.insert(0, location);
      await _saveFavoritesList(currentFavorites);
    }

    return currentFavorites;
  }

  /// Menghapus lokasi dari daftar favorit
  Future<List<LocationModel>> removeFavoriteLocation(
      LocationModel location) async {
    final currentFavorites = await getFavoriteLocations();
    currentFavorites.removeWhere((item) => item == location);
    await _saveFavoritesList(currentFavorites);
    return currentFavorites;
  }

  Future<void> _saveFavoritesList(List<LocationModel> locations) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList =
        locations.map((loc) => json.encode(loc.toJson())).toList();
    await prefs.setStringList(ApiConstants.favoriteLocationsKey, jsonList);
  }

  /// Menyimpan lokasi terakhir yang dipilih agar tetap muncul saat aplikasi dibuka ulang
  Future<void> saveLastSelectedLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      ApiConstants.lastSelectedLocationKey,
      json.encode(location.toJson()),
    );
  }

  /// Mengambil lokasi terakhir yang dipilih, atau default ke Purwokerto jika belum ada
  Future<LocationModel> getLastSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString =
        prefs.getString(ApiConstants.lastSelectedLocationKey);

    if (jsonString == null || jsonString.isEmpty) {
      return LocationModel.defaultLocation();
    }

    try {
      final Map<String, dynamic> map =
          json.decode(jsonString) as Map<String, dynamic>;
      return LocationModel.fromJson(map);
    } catch (_) {
      return LocationModel.defaultLocation();
    }
  }
}
