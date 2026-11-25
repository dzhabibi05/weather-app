import '../core/api_constants.dart';

class LocationModel {
  final int? id;
  final String name;
  final String? admin1;
  final String country;
  final double latitude;
  final double longitude;

  const LocationModel({
    this.id,
    required this.name,
    this.admin1,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.defaultLocation() {
    return const LocationModel(
      name: ApiConstants.defaultCityName,
      admin1: ApiConstants.defaultAdmin1,
      country: ApiConstants.defaultCountry,
      latitude: ApiConstants.defaultLatitude,
      longitude: ApiConstants.defaultLongitude,
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int?,
      name: (json['name'] as String?) ?? 'Lokasi Tidak Diketahui',
      admin1: json['admin1'] as String?,
      country: (json['country'] as String?) ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'admin1': admin1,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get subtitle {
    final parts = <String>[
      if (admin1 != null && admin1!.trim().isNotEmpty) admin1!.trim(),
      if (country.trim().isNotEmpty) country.trim(),
    ];
    return parts.join(', ');
  }

  String get coordinatesLabel {
    return '${latitude.toStringAsFixed(2)}°, ${longitude.toStringAsFixed(2)}°';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LocationModel) return false;
    return name.toLowerCase() == other.name.toLowerCase() &&
        (latitude - other.latitude).abs() < 0.01 &&
        (longitude - other.longitude).abs() < 0.01;
  }

  @override
  int get hashCode => Object.hash(
        name.toLowerCase(),
        latitude.toStringAsFixed(2),
        longitude.toStringAsFixed(2),
      );
}
