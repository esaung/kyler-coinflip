import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/app_theme.dart';

/// Banner ad widget with loading state
class AdBannerWidget extends StatelessWidget {
  final BannerAd? ad;
  final bool showAds;

  const AdBannerWidget({
    super.key,
    this.ad,
    this.showAds = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showAds || ad == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: ad!.size.width.toDouble(),
      height: ad!.size.height.toDouble(),
      decoration: BoxDecoration(
        color: AppTheme.backgroundMedium,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AdWidget(ad: ad!),
    );
  }
}

/// Placeholder for when ads are loading
class AdPlaceholder extends StatelessWidget {
  const AdPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundMedium.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.textMuted.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: const Center(
        child: Text(
          'Advertisement',
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
