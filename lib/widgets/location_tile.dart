import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/location_model.dart';

class LocationTile extends StatelessWidget {
  final LocationModel location;
  final bool isFavorite;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const LocationTile({
    super.key,
    required this.location,
    required this.isFavorite,
    this.isSelected = false,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(minHeight: 76),
          padding:
              const EdgeInsets.only(left: 16, right: 8, top: 12, bottom: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? SkylearnColors.sky.withValues(alpha: 0.16)
                    : SkylearnColors.skySoft.withValues(alpha: 0.5))
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isSelected ? SkylearnColors.sky : theme.colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Ikon Pin Lokasi
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? SkylearnColors.sky
                      : (isDark
                          ? SkylearnColors.sky.withValues(alpha: 0.2)
                          : SkylearnColors.skySoft),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 26,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                          ? SkylearnColors.skyBright
                          : SkylearnColors.sky),
                ),
              ),
              const SizedBox(width: 14),

              // Nama Kota, Wilayah/Negara & Koordinat
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            location.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: SkylearnColors.leafSoft,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Aktif',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: SkylearnColors.leafDeep,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (location.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        location.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      location.coordinatesLabel,
                      style: AppTheme.monoMetric(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: SkylearnColors.inkSubtle,
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol Bintang Favorit (Minimum 56x56 tap target)
              Tooltip(
                message: isFavorite
                    ? 'Hapus dari lokasi favorit'
                    : 'Simpan ke lokasi favorit',
                child: InkWell(
                  onTap: onToggleFavorite,
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Center(
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isFavorite
                              ? (isDark
                                  ? SkylearnColors.sun.withValues(alpha: 0.2)
                                  : SkylearnColors.sunSoft)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 28,
                          color: isFavorite
                              ? SkylearnColors.sun
                              : SkylearnColors.inkSubtle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
