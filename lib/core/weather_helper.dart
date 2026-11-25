import 'package:flutter/material.dart';
import 'app_theme.dart';

class WeatherConditionInfo {
  final String label;
  final IconData icon;
  final Color accentColor;
  final Color softBackgroundColor;

  const WeatherConditionInfo({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.softBackgroundColor,
  });
}

class WeatherHelper {
  WeatherHelper._();

  static WeatherConditionInfo getConditionInfo(int code) {
    if (code == 0) {
      return const WeatherConditionInfo(
        label: 'Cerah',
        icon: Icons.wb_sunny_rounded,
        accentColor: SkylearnColors.sunDeep,
        softBackgroundColor: SkylearnColors.sunSoft,
      );
    } else if (code == 1 || code == 2) {
      return const WeatherConditionInfo(
        label: 'Cerah Berawan',
        icon: Icons.wb_cloudy_rounded,
        accentColor: SkylearnColors.sky,
        softBackgroundColor: SkylearnColors.skySoft,
      );
    } else if (code == 3) {
      return const WeatherConditionInfo(
        label: 'Mendung',
        icon: Icons.cloud_rounded,
        accentColor: SkylearnColors.inkMuted,
        softBackgroundColor: SkylearnColors.surfaceSunken,
      );
    } else if (code == 45 || code == 48) {
      return const WeatherConditionInfo(
        label: 'Berkabut',
        icon: Icons.foggy,
        accentColor: SkylearnColors.inkMuted,
        softBackgroundColor: SkylearnColors.surfaceSunken,
      );
    } else if (code >= 51 && code <= 57) {
      return const WeatherConditionInfo(
        label: 'Gerimis',
        icon: Icons.grain_rounded,
        accentColor: SkylearnColors.sky,
        softBackgroundColor: SkylearnColors.skySoft,
      );
    } else if ((code >= 61 && code <= 67) || (code >= 80 && code <= 82)) {
      return const WeatherConditionInfo(
        label: 'Hujan',
        icon: Icons.water_drop_rounded,
        accentColor: SkylearnColors.skyDeep,
        softBackgroundColor: SkylearnColors.skySoft,
      );
    } else if ((code >= 71 && code <= 77) || (code >= 85 && code <= 86)) {
      return const WeatherConditionInfo(
        label: 'Salju',
        icon: Icons.ac_unit_rounded,
        accentColor: SkylearnColors.sky,
        softBackgroundColor: SkylearnColors.skySoft,
      );
    } else if (code >= 95 && code <= 99) {
      return const WeatherConditionInfo(
        label: 'Hujan Petir',
        icon: Icons.thunderstorm_rounded,
        accentColor: SkylearnColors.berry,
        softBackgroundColor: SkylearnColors.berrySoft,
      );
    }

    return const WeatherConditionInfo(
      label: 'Berawan',
      icon: Icons.cloud_queue_rounded,
      accentColor: SkylearnColors.sky,
      softBackgroundColor: SkylearnColors.skySoft,
    );
  }
}