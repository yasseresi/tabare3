# 🩸 Tabare3 — تبرع٣

**Tabare3** is an Arabic-first mobile application built with Flutter that connects **blood donors** with **patients in need**. The app supports two distinct user roles — *Donor* and *Requester* — each with their own dedicated home experience, making it easy to give and receive life-saving help.

---

## ✨ Features

### 🔐 Authentication
- Splash screen with animated loading indicator
- Login & Sign-up flows
- Role selection screen — choose to be a **Donor** (أنا متبرع) or a **Requester** (أحتاج دم)

### 🧑‍🤝‍🧑 Donor Side
| Screen | Description |
|--------|-------------|
| **Donor Home** | Dashboard with eligibility status, donation stats, and nearby blood requests |
| **Blood Requests** | Browse and accept nearby requests filtered by blood type and urgency |
| **Appointments** | View upcoming donation appointments |
| **Donation Record** | Track personal donation history |
| **Profile** | Manage personal and medical info |

### 🏥 Requester Side
| Screen | Description |
|--------|-------------|
| **Requester Home** | Dashboard overview of active requests |
| **Create Request** | Submit a new blood request with urgency level and hospital details |
| **My Requests** | View and manage all submitted requests |
| **Edit Request** | Update an existing request |
| **Donor History** | See donors who have responded to your requests |
| **Notifications** | Stay updated on request responses |

---

## 🏗️ Architecture

The project follows **Clean Architecture** principles with a **feature-first** directory structure:

```
lib/
├── core/
│   ├── error/          # Failures & exceptions
│   └── usecases/       # Base UseCase abstraction
├── features/
│   ├── auth/           # Login, Sign-up, Role selection
│   ├── donor_home/     # Donor dashboard & sub-screens
│   ├── requester_home/ # Requester dashboard & sub-screens
│   ├── profile/        # User profile
│   ├── splash/         # Splash/loading screen
│   └── counter/        # Example BLoC feature (template)
├── injection_container.dart  # Dependency injection setup
└── main.dart
```

Each feature follows the **3-layer separation**:

```
feature/
├── data/
│   ├── datasources/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

---

## 🛠️ Tech Stack

| Category | Package | Purpose |
|----------|---------|---------|
| **State Management** | [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) ^9.0.0 | BLoC/Cubit pattern |
| **Dependency Injection** | [`get_it`](https://pub.dev/packages/get_it) ^8.0.2 | Service locator |
| **Functional Programming** | [`dartz`](https://pub.dev/packages/dartz) ^0.10.1 | `Either` type for error handling |
| **Equality** | [`equatable`](https://pub.dev/packages/equatable) ^2.0.7 | Value-based equality for BLoC states |
| **Fonts** | [`google_fonts`](https://pub.dev/packages/google_fonts) ^6.2.1 | Cairo Arabic font |
| **SVG Support** | [`flutter_svg`](https://pub.dev/packages/flutter_svg) ^2.0.10 | SVG icons rendering |

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| **Primary Color** | `#8B1D1D` (Deep Red) |
| **Secondary Color** | `#4CAF50` (Green) |
| **Font Family** | Cairo (Google Fonts) |
| **Material Design** | Material 3 |
| **Text Direction** | RTL (Right-to-Left) |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) `^3.8.1`
- Dart SDK `^3.8.1`
- An Android/iOS emulator or physical device

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/your-username/tabare3.git
cd tabare3

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Build for Release

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 📁 Assets

```
assets/
├── images/
│   ├── logo.png        # App logo (used on splash screen)
│   ├── demo.png        # Donor stats card illustration
│   ├── demo1.png
│   └── icon6–9.png     # Role & UI illustrations
└── icons/
    └── icon1–7.svg     # Bottom navigation & UI icons
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test
```

Test files are located in the `test/` directory.

---

## 🌍 Localization

The app is currently built for **Arabic-speaking users** with RTL layout support throughout. All UI strings are in Arabic.

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'feat: add your feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 📄 License

This project is private and not published to pub.dev (`publish_to: none`).

---

> *"من نفّس عن مؤمن كربةً من كرب الدنيا، نفّس الله عنه كربةً من كرب يوم القيامة"*
> — رواه مسلم
