import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/weather_helper.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final LocationModel location;
  final CurrentWeather current;
  final String timezone;

  const CurrentWeatherCard({
    super.key,
    required this.location,
    required this.current,
    required this.timezone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final condition = WeatherHelper.getConditionInfo(current.weatherCode);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: SkylearnColors.sky.withValues(alpha: isDark ? 0.5 : 0.35),
          width: 2,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: SkylearnColors.sky.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge Kondisi Cuaca & Zona Waktu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? condition.accentColor.withValues(alpha: 0.2)
                      : condition.softBackgroundColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      condition.icon,
                      size: 20,
                      color: isDark
                          ? SkylearnColors.sunBright
                          : condition.accentColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      condition.label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isDark
                            ? theme.colorScheme.onSurface
                            : condition.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Text(
                  timezone,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: SkylearnColors.inkSubtle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Suhu Utama & Ikon Cuaca Besar
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${current.temperature.round()}°C',
                      style: AppTheme.monoMetric(
                        fontSize: 54,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.thermostat_rounded,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Terasa seperti ${current.apparentTemperature.toStringAsFixed(1)}°C',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: isDark
                      ? condition.accentColor.withValues(alpha: 0.18)
                      : condition.softBackgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  condition.icon,
                  size: 48,
                  color:
                      isDark ? SkylearnColors.sunBright : condition.accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
