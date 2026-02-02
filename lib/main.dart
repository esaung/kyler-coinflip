import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/app_theme.dart';
import 'providers/providers.dart';
import 'services/services.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.backgroundDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize services
  final storageService = StorageService();
  await storageService.initialize();

  final hapticService = HapticService();
  final audioService = AudioService();
  await audioService.initialize();

  final adService = AdService();
  // Initialize ads only in production
  // await adService.initialize();

  final purchaseService = PurchaseService();
  await purchaseService.initialize();

  runApp(
    CoinFlipperApp(
      storageService: storageService,
      hapticService: hapticService,
      audioService: audioService,
      adService: adService,
      purchaseService: purchaseService,
    ),
  );
}

class CoinFlipperApp extends StatelessWidget {
  final StorageService storageService;
  final HapticService hapticService;
  final AudioService audioService;
  final AdService adService;
  final PurchaseService purchaseService;

  const CoinFlipperApp({
    super.key,
    required this.storageService,
    required this.hapticService,
    required this.audioService,
    required this.adService,
    required this.purchaseService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Settings provider (needs to be first to provide premium status)
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(
            storageService: storageService,
            hapticService: hapticService,
            audioService: audioService,
            purchaseService: purchaseService,
            adService: adService,
          )..initialize(),
        ),

        // Coin flip provider
        ChangeNotifierProvider(
          create: (_) => CoinFlipProvider(
            storageService: storageService,
            hapticService: hapticService,
            audioService: audioService,
            adService: adService,
          )..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'Coin Flipper',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

/// Splash screen with loading animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Navigate to home after splash
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated coin icon
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        center: Alignment.topLeft,
                        radius: 1.2,
                        colors: [
                          Color(0xFFFFE4B5),
                          AppTheme.accentGold,
                          Color(0xFFDAA520),
                        ],
                        stops: [0.0, 0.3, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentGold.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.monetization_on,
                        size: 60,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // App name
                Opacity(
                  opacity: _opacityAnimation.value,
                  child: const Text(
                    'COIN FLIPPER',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Opacity(
                  opacity: _opacityAnimation.value,
                  child: Text(
                    'Make decisions easy',
                    style: TextStyle(
                      color: AppTheme.textSecondary.withOpacity(0.7),
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Animated builder helper widget
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
