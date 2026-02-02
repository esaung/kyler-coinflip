# Coin Flipper

A premium mobile utility app that provides a digital solution for 50/50 decision-making with tactile satisfaction and personalization.

## Features

### Core Mechanics
- **True Randomization**: Cryptographically secure random number generator ensuring fair 50/50 probability
- **Touch Interaction**: Tap the coin or use the flip button to trigger flips
- **History Log**: View the last 20 flip results with timestamps
- **Streak Counter**: Track consecutive same-result flips for engagement

### Visuals & Feedback
- **3D Animation**: Smooth coin rotation with realistic physics simulation
- **Haptic Feedback**: Vibrations synchronized with flip and landing
- **Multiple Skins**: Choose from Classic, Silver, Bronze, Golden, Cyberpunk, and Neon designs

### Monetization
- **Freemium Model**: Free with non-intrusive ads
- **Premium Unlock ($1.99)**:
  - Remove all advertisements
  - Unlock Golden, Cyberpunk, and Neon premium skins

## Screenshots

| Home Screen | Flip Animation | Skins Gallery |
|-------------|----------------|---------------|
| Main coin flip interface | 3D animated coin flip | Skin selection screen |

## Getting Started

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / Xcode for mobile deployment

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/coin-flipper.git
cd coin-flipper
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Hive adapters (if needed):
```bash
flutter packages pub run build_runner build
```

4. Run the app:
```bash
flutter run
```

### Configuration

#### Google Mobile Ads
Replace the placeholder App IDs in:
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

With your actual AdMob App ID.

#### In-App Purchases
Configure your products in:
- Google Play Console (Android)
- App Store Connect (iOS)

Update the product ID in `lib/constants/app_constants.dart` if needed.

## Project Structure

```
lib/
├── constants/          # App-wide constants and theme
│   ├── app_constants.dart
│   └── app_theme.dart
├── models/             # Data models
│   ├── flip_result.dart
│   ├── coin_skin.dart
│   └── user_stats.dart
├── providers/          # State management
│   ├── coin_flip_provider.dart
│   └── settings_provider.dart
├── screens/            # UI screens
│   ├── home_screen.dart
│   ├── history_screen.dart
│   ├── skins_screen.dart
│   └── settings_screen.dart
├── services/           # Business logic
│   ├── randomization_service.dart
│   ├── storage_service.dart
│   ├── haptic_service.dart
│   ├── audio_service.dart
│   ├── ad_service.dart
│   └── purchase_service.dart
├── widgets/            # Reusable UI components
│   ├── coin_widget.dart
│   ├── flip_button.dart
│   ├── streak_counter.dart
│   └── ...
└── main.dart           # App entry point
```

## Technical Details

### Randomization
Uses Dart's `Random.secure()` for cryptographically secure random number generation, ensuring true 50/50 probability for each flip.

### Animation
The coin animation uses Flutter's animation system with:
- Multiple rotation phases (acceleration, spin, deceleration)
- Realistic bounce effect on landing
- Continuous shine effect overlay

### State Management
Uses Provider for reactive state management across the app.

### Data Persistence
- **Hive**: For efficient flip history storage
- **SharedPreferences**: For user settings and stats

## Dependencies

| Package | Purpose |
|---------|---------|
| provider | State management |
| hive_flutter | Local database |
| shared_preferences | Settings storage |
| vibration | Haptic feedback |
| audioplayers | Sound effects |
| google_mobile_ads | Advertisement |
| in_app_purchase | Premium purchases |

## Building for Production

### Android
```bash
flutter build apk --release
# or for App Bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Marketing Keywords (ASO)
- Decision Maker
- Coin Toss
- Random Picker
- Heads or Tails
- Flip a Coin
- 50/50 Decision

## License

MIT License - See LICENSE file for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
