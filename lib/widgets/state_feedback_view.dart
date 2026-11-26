import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class StateFeedbackView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color accentColor;
  final Color softBackgroundColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  const StateFeedbackView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.accentColor,
    required this.softBackgroundColor,
    this.actionLabel,
    this.onAction,
  });

  factory StateFeedbackView.loading({
    String message = 'Sedang memuat data cuaca terbaru...',
  }) {
    return StateFeedbackView(
      icon: Icons.cloud_sync_rounded,
      title: 'Mohon Tunggu Sebentar',
      message: message,
      accentColor: SkylearnColors.sky,
      softBackgroundColor: SkylearnColors.skySoft,
    );
  }

  factory StateFeedbackView.error({
    required String message,
    required VoidCallback onRetry,
    String title = 'Ups, Terjadi Kendala',
  }) {
    return StateFeedbackView(
      icon: Icons.wifi_off_rounded,
      title: title,
      message: message,
      accentColor: SkylearnColors.coral,
      softBackgroundColor: SkylearnColors.coralSoft,
      actionLabel: 'Coba Lagi',
      onAction: onRetry,
    );
  }

  factory StateFeedbackView.empty({
    required String title,
    required String message,
    IconData icon = Icons.search_off_rounded,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return StateFeedbackView(
      icon: icon,
      title: title,
      message: message,
      accentColor: SkylearnColors.sky,
      softBackgroundColor: SkylearnColors.skySoft,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = actionLabel == null && title == 'Mohon Tunggu Sebentar';

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 440),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isLoading
                  ? theme.colorScheme.outline
                  : accentColor.withValues(alpha: 0.45),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: softBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          strokeWidth: 3.5,
                          color: SkylearnColors.sky,
                        ),
                      )
                    : Icon(
                        icon,
                        size: 36,
                        color: accentColor,
                      ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: onAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor == SkylearnColors.coral
                          ? SkylearnColors.sky
                          : accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 22),
                    label: Text(actionLabel!),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
