import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';

class WeatherApiException implements Exception {
  final String message;
  const WeatherApiException(this.message);

  @override
  String toString() => message;
}

class WeatherApiService {
  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mencari daftar kota berdasarkan kata kunci menggunakan Open-Meteo Geocoding API
  Future<List<LocationModel>> searchCities(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return [];
    }

    final uri = Uri.parse(ApiConstants.geocodingBaseUrl).replace(
      queryParameters: {
        'name': trimmedQuery,
        'count': '10',
        'language': 'id',
        'format': 'json',
      },
    );

    try {
      final response = await _client.get(uri).timeout(
            const Duration(seconds: 15),
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;

        if (!data.containsKey('results') || data['results'] == null) {
          return [];
        }

        final List<dynamic> results = data['results'] as List<dynamic>;
        return results
            .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw WeatherApiException(
          'Gagal mencari lokasi (Kode status: ${response.statusCode}).',
        );
      }
    } on SocketException {
      throw const WeatherApiException(
        'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
      );
    } on TimeoutException {
      throw const WeatherApiException(
        'Waktu permintaan habis. Server membutuhkan waktu terlalu lama.',
      );
    } on FormatException {
      throw const WeatherApiException(
        'Format data lokasi dari server tidak valid.',
      );
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException('Terjadi kesalahan saat mencari kota: $e');
    }
  }

  /// Mengambil data cuaca terkini & prakiraan harian dari Open-Meteo Weather Forecast API
  Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(ApiConstants.weatherBaseUrl).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': ApiConstants.currentVariables,
        'daily': ApiConstants.dailyVariables,
        'timezone': ApiConstants.defaultTimezone,
      },
    );

    try {
      final response = await _client.get(uri).timeout(
            const Duration(seconds: 15),
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(data);
      } else {
        throw WeatherApiException(
          'Gagal memuat data cuaca (Kode status: ${response.statusCode}).',
        );
      }
    } on SocketException {
      throw const WeatherApiException(
        'Tidak ada koneksi internet. Periksa jaringan Anda lalu coba lagi.',
      );
    } on TimeoutException {
      throw const WeatherApiException(
        'Waktu permintaan habis. Gagal terhubung ke layanan cuaca.',
      );
    } on FormatException {
      throw const WeatherApiException(
        'Format data cuaca dari server tidak valid.',
      );
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException('Terjadi kesalahan saat memuat cuaca: $e');
    }
  }
}
