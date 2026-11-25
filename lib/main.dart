import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'services/local_storage_service.dart';
import 'services/weather_api_service.dart';
import 'viewmodels/location_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CuacaSkylearnApp());
}

class CuacaSkylearnApp extends StatelessWidget {
  const CuacaSkylearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherApiService = WeatherApiService();
    final localStorageService = LocalStorageService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherViewModel>(
          create: (_) => WeatherViewModel(
            apiService: weatherApiService,
            storageService: localStorageService,
          ),
        ),
        ChangeNotifierProvider<LocationViewModel>(
          create: (_) => LocationViewModel(
            apiService: weatherApiService,
            storageService: localStorageService,
          ),
        ),
      ],
      child: Consumer<WeatherViewModel>(
        builder: (context, weatherViewModel, _) {
          return MaterialApp(
            title: 'Cuaca Skylearn',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: weatherViewModel.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
