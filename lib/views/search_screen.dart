import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/location_model.dart';
import '../viewmodels/location_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/location_tile.dart';
import '../widgets/state_feedback_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationVm = context.read<LocationViewModel>();
      locationVm.clearSearch();
      locationVm.loadFavorites();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onSelectLocation(LocationModel location) async {
    final weatherVm = context.read<WeatherViewModel>();
    Navigator.of(context).pop();
    await weatherVm.selectLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeLocation = context
        .select<WeatherViewModel, LocationModel>((vm) => vm.selectedLocation);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        leadingWidth: 64,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Kembali',
          constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
          icon: const Icon(Icons.arrow_back_rounded, size: 26),
        ),
        title: const Text('Cari & Kelola Lokasi'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kolom Input Pencarian Kota
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Consumer<LocationViewModel>(
                    builder: (context, locationVm, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              textInputAction: TextInputAction.search,
                              style: theme.textTheme.bodyLarge,
                              onChanged: locationVm.onSearchQueryChanged,
                              onSubmitted: (value) =>
                                  locationVm.searchCities(value),
                              decoration: InputDecoration(
                                hintText:
                                    'Ketik nama kota (mis. Bandung, Tokyo)...',
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  size: 24,
                                  color: SkylearnColors.sky,
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          _searchController.clear();
                                          locationVm.clearSearch();
                                        },
                                        tooltip: 'Hapus pencarian',
                                        constraints: const BoxConstraints(
                                          minWidth: 56,
                                          minHeight: 56,
                                        ),
                                        icon: const Icon(Icons.close_rounded),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                locationVm.searchCities(_searchController.text);
                              },
                              child: const Text('Cari'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Konten Dinamis: Hasil Pencarian API atau Daftar Lokasi Favorit
                Expanded(
                  child: Consumer<LocationViewModel>(
                    builder: (context, locationVm, _) {
                      switch (locationVm.searchState) {
                        case SearchUiState.loading:
                          return StateFeedbackView.loading(
                            message:
                                'Mencari kota "${locationVm.searchQuery}"...',
                          );

                        case SearchUiState.error:
                          return StateFeedbackView.error(
                            title: 'Pencarian Gagal',
                            message: locationVm.errorMessage ??
                                'Tidak dapat mengambil daftar kota.',
                            onRetry: () =>
                                locationVm.searchCities(_searchController.text),
                          );

                        case SearchUiState.empty:
                          return StateFeedbackView.empty(
                            title: 'Kota Tidak Ditemukan',
                            message:
                                'Tidak ada hasil untuk "${locationVm.searchQuery}". Coba periksa ejaan atau gunakan nama kota lain.',
                            actionLabel: 'Reset Pencarian',
                            onAction: () {
                              _searchController.clear();
                              locationVm.clearSearch();
                            },
                          );

                        case SearchUiState.success:
                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                            itemCount: locationVm.searchResults.length + 1,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    'Hasil Pencarian (${locationVm.searchResults.length})',
                                    style: theme.textTheme.titleLarge,
                                  ),
                                );
                              }

                              final location =
                                  locationVm.searchResults[index - 1];
                              return LocationTile(
                                location: location,
                                isFavorite: locationVm.isFavorite(location),
                                isSelected: location == activeLocation,
                                onTap: () => _onSelectLocation(location),
                                onToggleFavorite: () =>
                                    locationVm.toggleFavorite(location),
                              );
                            },
                          );

                        case SearchUiState.idle:
                          return _buildFavoritesSection(
                            context,
                            locationVm,
                            activeLocation,
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesSection(
    BuildContext context,
    LocationViewModel locationVm,
    LocationModel activeLocation,
  ) {
    final theme = Theme.of(context);

    if (locationVm.isLoadingFavorites) {
      return StateFeedbackView.loading(
        message: 'Memuat daftar lokasi favorit...',
      );
    }

    if (locationVm.favoriteLocations.isEmpty) {
      return StateFeedbackView.empty(
        icon: Icons.star_outline_rounded,
        title: 'Belum Ada Lokasi Favorit',
        message:
            'Cari nama kota di kolom atas lalu tekan ikon bintang untuk menyimpannya di sini.',
        actionLabel: 'Mulai Cari Kota',
        onAction: () => _searchFocusNode.requestFocus(),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      itemCount: locationVm.favoriteLocations.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: SkylearnColors.sun,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Lokasi Favorit Tersimpan (${locationVm.favoriteLocations.length})',
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
          );
        }

        final favorite = locationVm.favoriteLocations[index - 1];
        return LocationTile(
          location: favorite,
          isFavorite: true,
          isSelected: favorite == activeLocation,
          onTap: () => _onSelectLocation(favorite),
          onToggleFavorite: () => locationVm.toggleFavorite(favorite),
        );
      },
    );
  }
}
