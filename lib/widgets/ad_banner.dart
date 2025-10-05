import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

/// Ad banner widget for displaying banner ads
/// 
/// Shows banner ads at the bottom of screens when user is not premium
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Load banner ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Banner ad failed to load: $error');
        },
      ),
    );

    _bannerAd?.load();
  }

  /// Get banner ad unit ID
  String _getBannerAdUnitId() {
    // Test ad unit ID - replace with your actual ad unit ID
    return 'ca-app-pub-3940256099942544/6300978111';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        // Don't show ads if user is premium
        if (appProvider.isPremium) {
          return const SizedBox.shrink();
        }

        // Don't show ads if not loaded
        if (!_isAdLoaded || _bannerAd == null) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.2),
              ),
            ),
          ),
          child: AdWidget(ad: _bannerAd!),
        );
      },
    );
  }
}
