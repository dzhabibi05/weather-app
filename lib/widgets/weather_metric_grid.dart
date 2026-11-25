import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/weather_model.dart';

class WeatherMetricGrid extends StatelessWidget {
  final CurrentWeather current;
  final int todayPrecipitationProbability;

  const WeatherMetricGrid({
    super.key,
    required this.current,
    required this.todayPrecipitationProbability,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricItemData(
        label: 'Kelembapan',
        value: '${current.relativeHumidity}%',
        icon: Icons.water_drop_outlined,
        accentColor: SkylearnColors.sky,
        softColor: SkylearnColors.skySoft,
      ),
      _MetricItemData(
        label: 'Kecepatan Angin',
        value: '${current.windSpeed.toStringAsFixed(1)} km/j',
        icon: Icons.air_rounded,
        accentColor: SkylearnColors.leafDeep,
        softColor: SkylearnColors.leafSoft,
      ),
      _MetricItemData(
        label: 'Curah Hujan',
        value: '${current.precipitation.toStringAsFixed(1)} mm',
        icon: Icons.umbrella_rounded,
        accentColor: SkylearnColors.berry,
        softColor: SkylearnColors.berrySoft,
      ),
      _MetricItemData(
        label: 'Peluang Hujan',
        value: '$todayPrecipitationProbability%',
        icon: Icons.cloudy_snowing,
        accentColor: SkylearnColors.sunDeep,
        softColor: SkylearnColors.sunSoft,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 640 ? 4 : 2;
        final itemWidth = (constraints.maxWidth - (16 * (crossAxisCount - 1))) /
            crossAxisCount;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: metrics.map((metric) {
            return SizedBox(
              width: itemWidth,
              child: _MetricCard(data: metric),
            );
          }).toList(),
        );
      },
    );
  }
}

class _MetricItemData {
  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;
  final Color softColor;

  const _MetricItemData({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.softColor,
  });
}

class _MetricCard extends StatelessWidget {
  final _MetricItemData data;

  const _MetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? data.accentColor.withValues(alpha: 0.2)
                  : data.softColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              data.icon,
              size: 24,
              color: isDark ? Colors.white : data.accentColor,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            data.label,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            data.value,
            style: AppTheme.monoMetric(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
