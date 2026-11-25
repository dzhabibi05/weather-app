import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_item.dart';
import '../widgets/state_feedback_view.dart';
import '../widgets/weather_metric_grid.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<WeatherViewModel>();
      if (viewModel.state == WeatherUiState.initial) {
        viewModel.initWeather();
      }
    });
  }

  void _openSearchScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SearchScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 20,
        title: Consumer<WeatherViewModel>(
          builder: (context, vm, _) {
            return InkWell(
              onTap: _openSearchScreen,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: SkylearnColors.skySoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: SkylearnColors.sky,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  vm.selectedLocation.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.headlineSmall,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                          if (vm.selectedLocation.subtitle.isNotEmpty)
                            Text(
                              vm.selectedLocation.subtitle,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          // Tombol Toggle Tema Terang / Gelap (56x56 touch target)
          Consumer<WeatherViewModel>(
            builder: (context, vm, _) {
              return IconButton(
                onPressed: vm.toggleTheme,
                tooltip: vm.isDarkMode
                    ? 'Beralih ke Mode Terang'
                    : 'Beralih ke Mode Gelap',
                constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
                icon: Icon(
                  vm.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  size: 24,
                ),
              );
            },
          ),
          // Tombol Navigasi ke Search / Location Screen (56x56 touch target)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.filledTonal(
              onPressed: _openSearchScreen,
              tooltip: 'Cari & Kelola Lokasi',
              constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.search_rounded, size: 26),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<WeatherViewModel>(
          builder: (context, vm, _) {
            switch (vm.state) {
              case WeatherUiState.initial:
              case WeatherUiState.loading:
                return StateFeedbackView.loading(
                  message:
                      'Mengambil info cuaca untuk ${vm.selectedLocation.name}...',
                );

              case WeatherUiState.error:
                return StateFeedbackView.error(
                  message: vm.errorMessage ??
                      'Gagal memuat informasi cuaca. Silakan coba lagi.',
                  onRetry: vm.retry,
                );

              case WeatherUiState.empty:
                return StateFeedbackView.empty(
                  title: 'Data Cuaca Tidak Tersedia',
                  message:
                      'Tidak ada data prakiraan cuaca untuk lokasi ${vm.selectedLocation.name}.',
                  actionLabel: 'Cari Kota Lain',
                  onAction: _openSearchScreen,
                );

              case WeatherUiState.success:
                final weather = vm.weatherData!;
                return RefreshIndicator(
                  color: SkylearnColors.sky,
                  onRefresh: () => vm.fetchWeather(isRefresh: true),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 840),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Kartu Kondisi Cuaca Terkini
                            CurrentWeatherCard(
                              location: vm.selectedLocation,
                              current: weather.current,
                              timezone: weather.timezone,
                            ),
                            const SizedBox(height: 24),

                            // 2. Detail Kondisi Cuaca (Kelembapan, Angin, Curah Hujan, Peluang Hujan)
                            Text(
                              'Detail Kondisi Saat Ini',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            WeatherMetricGrid(
                              current: weather.current,
                              todayPrecipitationProbability:
                                  weather.todayPrecipitationProbability,
                            ),
                            const SizedBox(height: 28),

                            // 3. Prakiraan Cuaca Harian (7 Hari ke Depan)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Prakiraan ${weather.daily.length} Hari Ke Depan',
                                  style: theme.textTheme.titleLarge,
                                ),
                                Text(
                                  'Min / Maks',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: weather.daily.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                return DailyForecastItem(
                                  forecast: weather.daily[index],
                                  isToday: index == 0,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
