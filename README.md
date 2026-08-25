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

The project follows **Clean Architecture** principles with a **feature-first** directory structure and a swappable **backend abstraction**:

```
lib/
├── core/
│   ├── backend/        # Backend interface + error mapper contract
│   ├── constants/      # App strings, dimensions, env constants
│   ├── error/          # Failures & exceptions
│   ├── theme/          # Colors, typography
│   └── usecases/       # Base UseCase abstraction
├── backend/
│   ├── active_backend.dart   # Single switch point (SupabaseBackend | RestBackend)
│   ├── rest/                 # Django REST implementation
│   └── supabase/             # Supabase implementation (on supabase-backend branch)
├── features/
│   ├── auth/                 # Login, Sign-up, Role selection
│   ├── donor_home/           # Donor dashboard & sub-screens
│   ├── requester_home/       # Requester dashboard & sub-screens
│   ├── notifications/        # In-app notifications + realtime bell
│   ├── profile/              # User profile
│   └── splash/               # Splash/loading screen
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
| **Localization** | [`easy_localization`](https://pub.dev/packages/easy_localization) | Arabic / English strings + RTL |
| **REST backend** | [`dio`](https://pub.dev/packages/dio) | HTTP client for the Django REST API |
| **Supabase backend** | [`supabase_flutter`](https://pub.dev/packages/supabase_flutter) | Auth, Postgres RPCs, Realtime (on `supabase-backend` branch) |
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
git clone https://github.com/Mouaadmoudraa/tabara3.git
cd tabara3

# 2. Install dependencies
flutter pub get
```

### Run (default: REST backend)

The `main` and `feature/rest-backend-migration` branches target the Django REST API. Point the app at your API host via `--dart-define`:

```bash
flutter run --dart-define=API_BASE_URL=https://your-api-host/api
```

### Build for Release

```bash
# Android
flutter build apk --release --dart-define=API_BASE_URL=https://your-api-host/api

# iOS
flutter build ios --release --dart-define=API_BASE_URL=https://your-api-host/api
```

---

## 🔌 Backend

The app talks to its backend through a single `Backend` interface (`lib/core/backend/backend.dart`). One line — `activeBackend` in `lib/backend/active_backend.dart` — picks the implementation, and every feature's `*RemoteDataSource` is bound in that backend's `registerDataSources()`.

Two implementations live on separate branches:

| Branch | `activeBackend` | Env vars |
|--------|-----------------|----------|
| `main`, `feature/rest-backend-migration` | `RestBackend` (Django REST) | `API_BASE_URL` |
| `supabase-backend` (a.k.a. `integration/full-parity`) | `SupabaseBackend` | `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY` |

Feature code, BLoCs, use cases, entities, and UI are identical across both — only `lib/backend/<name>/` and the datasource bindings change.

---

## 🗄️ Running the Supabase version

The Supabase-backed variant lives on the remote branch `supabase-backend` (mirrored locally as `integration/full-parity`). It includes the full SQL schema, RLS policies, RPCs, storage buckets, and Realtime wiring under `supabase/`.

### 1. Check out the branch

```bash
git fetch origin
git checkout -b supabase-backend origin/supabase-backend
flutter pub get
```

### 2. Provision a Supabase project

Either use an existing hosted project or spin up a local stack.

**Option A — hosted project**

1. Create a project at [supabase.com](https://supabase.com).
2. Grab the project URL and the **publishable** API key (Project Settings → API).
3. Push the migrations:

   ```bash
   supabase link --project-ref <your-project-ref>
   supabase db push
   ```

**Option B — local stack (needs Docker)**

```bash
supabase start           # boots Postgres, GoTrue, Realtime, Storage on ports 54321/54322
supabase db reset        # applies every migration in supabase/migrations/
```

`supabase start` prints the local `API URL` and `anon key` — those are the values you pass to Flutter.

### 3. Run the app pointed at Supabase

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<project-ref>.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=<publishable-or-anon-key>
```

For local Supabase, use the URL/key printed by `supabase start` (URL is typically `http://127.0.0.1:54321`; on Android emulator use `http://10.0.2.2:54321`).

### 4. Notes & gotchas

- Migrations are the source of truth (`supabase/migrations/`). Do **not** hand-edit the remote schema — write a new migration and `supabase db push`.
- The remote history is authoritative; do not run `supabase db push` if local and remote diverge — reconcile first.
- Realtime bell/notifications require the notifications migration to be applied on the target project.
- Avatar uploads use the `profile_pic` storage bucket with RLS enforced (see migration `00005_profile_pic_storage_rls.sql`).

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

Arabic-first with RTL layout throughout, plus English fallback. Strings live under `assets/translations/` and are loaded via `easy_localization`. `startLocale` defaults to Arabic.

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
