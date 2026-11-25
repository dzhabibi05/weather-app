import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_theme.dart';
import '../core/weather_helper.dart';
import '../models/weather_model.dart';

class DailyForecastItem extends StatelessWidget {
  final DailyForecast forecast;
  final bool isToday;

  const DailyForecastItem({
    super.key,
    required this.forecast,
    this.isToday = false,
  });

  String _formatDayName(DateTime date) {
    if (isToday) return 'Hari Ini';
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[date.weekday - 1];
  }

  String _formatShortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final dayStr = DateFormat('dd').format(date);
    return '$dayStr ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final condition = WeatherHelper.getConditionInfo(forecast.weatherCode);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isToday
            ? (isDark
                ? SkylearnColors.sky.withValues(alpha: 0.14)
                : SkylearnColors.skySoft.withValues(alpha: 0.45))
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isToday ? SkylearnColors.sky : theme.colorScheme.outline,
          width: isToday ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Kolom Hari & Tanggal
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDayName(forecast.date),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatShortDate(forecast.date),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          // Ikon Cuaca & Peluang Hujan
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDark
                        ? condition.accentColor.withValues(alpha: 0.2)
                        : condition.softBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    condition.icon,
                    size: 24,
                    color: isDark
                        ? SkylearnColors.sunBright
                        : condition.accentColor,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        condition.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.water_drop_rounded,
                            size: 14,
                            color: SkylearnColors.sky,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${forecast.precipitationProbabilityMax}%',
                            style: AppTheme.monoMetric(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: SkylearnColors.sky,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Suhu Minimum & Maksimum Harian
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${forecast.minTemperature.round()}°',
                  style: AppTheme.monoMetric(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${forecast.maxTemperature.round()}°',
                  style: AppTheme.monoMetric(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
