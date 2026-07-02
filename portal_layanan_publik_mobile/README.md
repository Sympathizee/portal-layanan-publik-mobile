# Portal Layanan Publik Mobile

Aplikasi mobile untuk mengakses layanan publik pemerintah dengan mudah.

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.44.1+
- Dart SDK 3.6.0+
- Android Studio / VS Code

### Installation

```bash
# Clone repository
git clone [repository-url]
cd portal_layanan_publik_mobile

# Install dependencies
flutter pub get

# Run app
flutter run
```

## 📱 Features

- **Home**: Pencarian layanan, layanan populer, topik trending
- **Search**: Pencarian layanan (dalam pengembangan)
- **Services**: Daftar kategori layanan lengkap
- **Profile**: Profil pengguna (dalam pengembangan)

## 🏗️ Project Structure

```
lib/
├── app/              # Konfigurasi app (theme, router)
├── core/             # Utility & reusable widgets
├── features/         # Feature modules
│   ├── home/
│   ├── search/
│   ├── services/
│   └── profile/
└── shared/           # Shared models & types
```

## 🎨 Tech Stack

- **Flutter**: 3.44.1+
- **Architecture**: Feature-First + Clean Architecture
- **State Management**: StatefulWidget (akan upgrade ke Riverpod)

## 📝 Development

### Run Commands

```bash
# Development
flutter run

# Build APK
flutter build apk --release

# Run tests
flutter test

# Analyze code
flutter analyze
```

### Adding Logo

Letakkan file `LOGO_INAKU.png` di folder `assets/images/`

## 📚 Documentation

Untuk dokumentasi lengkap, lihat:
- Structure overview
- Development guide
- Widget usage examples

## 👥 Team

Developed by Kementerian Komunikasi dan Informatika

## 📄 License

[Your License Here]
