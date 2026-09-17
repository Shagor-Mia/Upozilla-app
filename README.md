# Upazila mobile app (Flutter) — Phase 3

Feature-first Flutter client for the Upazila Digital Ecosystem backend
(`backend/`, FastAPI, `/api/v1`). Implements Section 8 of
`UPAZILA_SAAS_IMPLEMENTATION_PLAN.md`: Riverpod + go_router, a Dio interceptor
chain (JWT attach, single refresh-on-401 + replay, capped backoff retry, debug
logging), a typed exception hierarchy, Hive read-cache with cache-then-network
repositories, bn/en/ar localization (bn default, switchable in the profile
screen), Sentry, and the min-supported-app-version gate.

## Status: compiles clean (Flutter 3.47.2 / Dart 3.13.2)

`flutter analyze` reports no issues and `flutter test` passes (2026-08-31).
`android/` and `ios/` were generated with `flutter create` and then patched:
Android product flavors `dev` / `staging` / `prod`, location + internet
permissions, `tel:`/`https:` package-visibility queries, and the iOS
`NSLocationWhenInUseUsageDescription` string. `pubspec.lock` is committed. A debug APK (`flutter build apk --debug --flavor dev`)
builds on this toolchain (Flutter 3.47.2, AGP 9.1, Gradle 9.3.1, Android SDK 36).

Build-environment notes baked into `android/`:
- `ndkVersion` is pinned to the locally installed NDK 27.1.12297006 (Flutter's
  default 28.2.x could not be auto-installed with the deprecated `sdkmanager`).
- `kotlin.incremental=false` in `gradle.properties`: incremental caches failed
  to close on Windows (file locks); plugin compiles are a few seconds slower.
- `buildFeatures.resValues = true` because AGP 9 disables `resValue` by default
  and the flavors use it for the launcher label.
- `flutter_secure_storage` stays on 10.x: 11.x requires compileSdk 37, which
  AGP 9.1 / the installed platform do not provide yet.

Deliberate deviations from Section 8 (until a real reason to change them):
hand-written immutable models instead of freezed + an OpenAPI-generated
dart-dio client (no Java toolchain needed to build), and `intl ^0.20.3`
because `flutter_localizations` on this SDK requires it.

### Setup (Flutter >= 3.22 / Dart >= 3.4; this repo was verified on 3.47.2)

```bash
cd app
flutter pub get      # also generates lib/core/l10n/generated/app_localizations.dart
flutter analyze
flutter test
```

`android/` and `ios/` are already generated and committed; do not run
`flutter create .` again unless you intend to regenerate them (re-apply the
flavor/permission patches afterwards - see Status above).

### Running

```bash
# Android emulator (10.0.2.2 = host machine's localhost)
flutter run --flavor dev \
  --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1 \
  -t lib/bootstrap/main_dev.dart

# Physical device on the same Wi-Fi: use the host's LAN IP instead of 10.0.2.2.
# iOS simulator can use http://localhost:8000/api/v1 directly.

# Staging / prod
flutter run --flavor staging --dart-define=API_BASE_URL=https://staging-api.example/api/v1 \
  --dart-define=SENTRY_DSN=... -t lib/bootstrap/main_staging.dart
flutter build appbundle --flavor prod --dart-define=API_BASE_URL=https://api.example/api/v1 \
  --dart-define=SENTRY_DSN=... -t lib/bootstrap/main_prod.dart
```

Supported `--dart-define` keys (read in `lib/core/config/app_config.dart`):

| Key | Default | Purpose |
|---|---|---|
| `API_BASE_URL` | `http://10.0.2.2:8000/api/v1` | Backend base URL including `/api/v1` |
| `FLAVOR` | `dev` | Only used by `lib/main.dart`; the `main_<flavor>.dart` targets set it explicitly |
| `SENTRY_DSN` | empty | Sentry is skipped entirely when empty |
| `MAPBOX_TOKEN` | empty | Reserved; no map widget is rendered yet |

Local dev needs the backend running with the console SMS gateway so
`POST /auth/otp/request` returns `dev_code`; the OTP screen shows it.

## Layout

```
lib/
├── main.dart                    # FLAVOR-define entrypoint
├── bootstrap/                   # bootstrap() + main_dev/staging/prod.dart
├── app/                         # MaterialApp.router, go_router, bottom-nav shell, version gate
├── core/
│   ├── api/                     # Dio factory, ApiClient (only place Dio errors are mapped), interceptors/
│   ├── auth/                    # session: AppUser, AuthState, AuthRepository, AuthController
│   ├── cache/                   # Hive JsonCache + cacheThenNetwork()
│   ├── config/                  # AppConfig from --dart-define
│   ├── error/                   # sealed AppException hierarchy + Dio mapper
│   ├── l10n/                    # app_bn/en/ar.arb, LocaleController (bn default), context.l10n extension (generated/ is gitignored)
│   ├── location/                # geolocator wrapper
│   ├── models/                  # GeoPoint/NearMeQuery, Paginated<T>, JSON helpers
│   ├── network/                 # connectivity_plus wrapper + isOfflineProvider
│   ├── observability/           # AppLogger, AnalyticsService (+Noop)
│   ├── routing/                 # AppRoutes path constants (mirror web URLs)
│   ├── storage/                 # TokenStorage (flutter_secure_storage)
│   ├── theme/, utils/, widgets/ # AsyncValueWidget, OfflineBanner, ErrorState, EmptyState, VerifiedBadge, DistanceChip…
└── features/<name>/{data,domain,presentation}/
    ├── auth/          phone OTP login/register + password login screens
    ├── home/          featured places + quick links
    ├── explore/       Places / Hospitals / Markets / Businesses tabs, "Near me", detail screens
    ├── marketplace/   Local Bazar products + Exchange listings, search, infinite scroll, detail
    ├── news/          list + detail (both cached for offline reading)
    ├── services/      government/union services list + detail
    ├── profile/       me / sign-out / app version; /meta force-update gate
    └── notifications/ placeholder (push not enabled)
test/                  pure-Dart unit tests (no codegen needed)
```

Rules enforced by structure (Section 8.1 / 8.8 / 20.5):

* Presentation never touches Dio. Screens read Riverpod providers; providers
  call repositories; repositories call `ApiClient`.
* `features/X` never imports `features/Y`. Cross-feature state lives in
  `core/` — that is why the auth *session* (`core/auth/`) is in core while the
  auth *screens* stay in `features/auth/`. `lib/app/` is the only composer that
  imports many features.
* Every list screen uses `AsyncValueWidget` so loading / offline / error /
  empty look the same everywhere.

## Deliberate deviations from the plan

* **Hand-written models instead of `freezed` + `json_serializable`, and no
  generated dart-dio client (Sections 8.1 / 8.2).** Code generation needs
  `build_runner`/`openapi-generator` (Java) which could not run here. Models are
  immutable classes with `fromJson`/`toJson`/`copyWith` written against
  `backend/app/modules/*/schemas.py`. When the toolchain is available:
  generate the dart-dio client from `/openapi.json` into `core/api/generated/`,
  migrate `features/*/domain` to freezed, and add the regeneration step to CI so
  a backend contract change fails mobile CI (Section 8.8).
* **`synthetic-package: false` in `l10n.yaml`.** Localizations are generated
  into `lib/core/l10n/generated/` (gitignored) instead of the deprecated
  `package:flutter_gen` synthetic package, so the import keeps working on
  Flutter ≥ 3.27. Import via `core/l10n/l10n.dart`.
* **Digits:** prices, distances and counts render with Latin digits in both
  locales (matches the web app and user-typed listing text); only dates follow
  the locale (Section 8.4 asked for an explicit decision).

## Deliberately deferred (not started)

* Push notifications (FCM / `firebase_messaging`) — no Firebase project;
  `features/notifications` is a placeholder screen.
* Firebase Analytics / Crashlytics / `facebook_app_events` — `AnalyticsService`
  is a no-op; swap the provider when a project exists.
* Mapbox map view (`mapbox_maps_flutter`) — Explore is list-based; see the TODO
  in `features/explore/presentation/widgets/near_me_bar.dart`.
* Facebook Login (`flutter_facebook_auth`).
* Write flows: create listing, favourites, contact reveal, messaging, reviews,
  reports, phone verification for existing accounts.
* Beta distribution (Firebase App Distribution / TestFlight), Fastlane, golden
  and integration tests, Melos split.

## Backend contract notes

* `GET /meta` and the `lat`/`lng`/`radius_km` "near me" parameters are the
  Phase 3 contract the app codes against. The version gate fails open when
  `/meta` is unreachable, so the app still works against a backend without it.
* `POST /auth/login` takes `{identifier, password}` (`identifier` = email or
  phone), matching `backend/app/modules/auth/schemas.py`.
* Error envelope handling (`core/error/dio_error_mapper.dart`) covers FastAPI's
  `{"detail": "..."}` and Pydantic's `{"detail": [{loc, msg, type}]}` shapes.
