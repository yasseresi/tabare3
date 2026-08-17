# SPEC — Migrate tabara3 off Supabase onto the blood-backend Django REST API

Status: DRAFT (awaiting approval)
Owner: yasseresi
Date: 2026-08-14
Branch base: `integration/full-parity`

> Note: repo root already holds an unrelated `SPEC.md` (profile-section, Jul 29).
> This migration spec is kept separate to avoid clobbering it.

---

## 1. Objective

Move the tabara3 Flutter client from its current Supabase backend to the
custom Django REST backend (`blood-backend`), live at
`https://blood-backend-dz.onrender.com/api/v1/`.

The migration seam already exists: every feature depends only on abstract
`*RemoteDataSource` contracts, `lib/backend/rest/` holds a compiling scaffold
with six stubbed data sources, and `RestClientFactory` (dio) is wired. The work
is to **fill the stubs against the real endpoints** and switch the app over
**one feature at a time**, keeping the three-tier test net green throughout.

Target users: unchanged — Algerian blood donors and recipients. This is an
infrastructure swap with **no intended change to app behavior or UI**, except
where the backend contract forces one (see §7 boundaries).

### Success criteria
- All six REST data sources call real endpoints; no `_todo()` / `UnimplementedError` remains.
- App boots and every user flow works end-to-end against the live Django API.
- Existing suite (384+ tests) stays green; new REST data-source tests added.
- Supabase code remains in-tree but unreferenced once cutover completes; deletion is a separate follow-up.

---

## 2. Key decisions (locked with user 2026-08-14)

| # | Decision | Choice | Consequence |
|---|----------|--------|-------------|
| D1 | Identity model (app=username, API=email) | **Fake-email bridge** | `username` → `username@tabara3.dz` sent to Django as email (mirrors the current Supabase trick in `auth_supabase_data_source.dart`). No auth-UI change; backend stores synthetic emails. |
| D2 | Cutover strategy | **Incremental per-feature** | A hybrid backend registers some data sources from REST, the rest from Supabase, gated per-feature. Validate each slice live before flipping the next. |
| D3 | Realtime notifications | **Polling** | Django REST has no realtime. `watchNotifications()` becomes a periodic `GET /notifications/` (default 30s) emitted onto the existing stream. Badge stays live-ish. |
| D4 | Session scope | **Spec + plan** | This file, then an ordered task plan. No production code this session. |

### Open items to resolve during build (not blocking the spec)
- **O1 Token persistence**: `RestClientFactory` holds the access token in memory
  only, no refresh wiring. Django issues `access` (60m) + `refresh` (30d). Plan
  must add secure token storage + `POST /auth/refresh/` on 401. Prior audit
  flagged SharedPreferences token storage — use `flutter_secure_storage`.
- **O2 Registration field parity**: Django register requires
  email/phone/first+last name/wilaya/blood-type; confirm the app's `SignupParams`
  carries all of them (map, don't invent).
- **O3 Model field mapping**: Supabase `users` row shape vs Django user/profile
  JSON. Each REST data source maps to the *existing* Model `fromJson`, or the
  Model gains an alias — decided per data source against the live response.

---

## 3. Endpoint map (live API → data source method)

Base: `https://blood-backend-dz.onrender.com/api/v1/`  ·  Auth: `Authorization: Bearer <access>`

### Auth / profile (`accounts`)
| Endpoint | Data-source method | Notes |
|---|---|---|
| `POST /auth/register/` | `AuthRest.signUp` | body: bridged email/password/phone/names/wilaya/blood_type |
| `POST /auth/login/` | `AuthRest.signIn` | returns `{access, refresh}`; throttled |
| `POST /auth/refresh/` | token refresh (interceptor) | on 401 |
| `GET /auth/email-available/` | `AuthRest.isUsernameAvailable` | pass bridged email |
| `GET /profile/` | `AuthRest.getCurrentUser`, `ProfileRest.getProfile` | |
| `PATCH /profile/` | `ProfileRest.updateProfile` | |
| `POST /profile/switch-mode/` | `updateUserRole` / `changeRole` | donor↔recipient |
| `POST /profile/toggle-status/` | toggle active status | |
| `GET /profile/eligibility/` | eligibility gate | |

### Blood requests + feed (`blood_requests`, `appointments`)
| Endpoint | Method |
|---|---|
| `GET /requests/` (mine) · `GET /requests/{id}/` · `POST /requests/` · `PATCH /requests/{id}/` | request CRUD |
| `GET /feed/requests/` | donor compatible requests |
| `POST /requests/{id}/accept/` · `POST /requests/{id}/invite/` | accept / invite |
| `GET /appointments/mine/` · appointments router | appointments |
| `POST /donations/scan/` · `POST /donations/scan/{token}/` | request-QR redeem |

### Campaigns (`campaigns`)
| `GET /feed/campaigns/` · `GET /campaigns/` · `POST /campaigns/scan/{token}/` | campaigns + campaign-QR redeem |

### Donor card / gamification (`gamification`)
| `GET /donor-card/` · `GET /donor-card/ledger/` · `GET /levels/` · `GET /badges/` | donor card + ledger |

### Notifications (`notifications`)
| `GET /notifications/` (poll) · `PATCH /notifications/{id}/` (mark read) · `POST /notifications/broadcast/` | notification centre |

### Reference data (`references`)
| `GET /references/wilayas/` · `/blood-types/` · `/chronic-diseases/` · `/hospitals/` · `/associations/` | dropdown/master data (hospitals used by request create) |

> Source of truth for exact field names: live `GET /api/schema/` (drf-spectacular
> OpenAPI) + `/api/docs/` Swagger. Confirm each response shape before mapping.

---

## 4. Data-source coverage (the six stubs)

| Data source | Stubbed methods | Backing endpoints |
|---|---|---|
| `AuthRestDataSource` | signIn, signUp, isUsernameAvailable, signOut, getCurrentUser, updateUserRole | `/auth/*`, `/profile/*` |
| `ProfileRestDataSource` | getProfile, updateProfile, changeRole, uploadAvatar | `/profile/*` (avatar: confirm — no FileField in backend, see O3) |
| `RequestRestDataSource` | listOwn, get, listHospitals, create, update, cancel, listDonors, listCompatibleDonors, listInvitations, inviteDonor, issueRequestQr | `/requests/*`, `/references/hospitals/` |
| `NotificationRestDataSource` | listNotifications, markAsRead, watchNotifications(poll) | `/notifications/*` |
| `DonorCardRestDataSource` | getDonorCard | `/donor-card/` |
| `DonorFeedRestDataSource` | availability, compatibleRequests, campaigns, appointments, donationRecords, accept, cancel, redeem(Request/Campaign)Qr | `/feed/*`, `/appointments/*`, `/donations/scan/*`, `/campaigns/scan/*` |

> Avatar upload (O3): backend README says no model stores uploads. Confirm whether
> `PATCH /profile/` accepts an avatar URL/base64, or drop avatar upload for REST
> (Ask-first item).

---

## 5. Project structure (touched paths)

```
lib/backend/
  active_backend.dart          # flip point
  rest/
    rest_backend.dart          # registers REST data sources
    rest_client.dart           # dio + token interceptor (add refresh + persistence)
    rest_error_mapper.dart     # Dio/HTTP -> Failure
    constants/rest_paths.dart   # NEW: endpoint path constants (no inline literals)
    datasources/rest_data_sources.dart  # 6 stubs -> implement
  hybrid/hybrid_backend.dart   # NEW (D2): composite Backend for per-feature cutover
lib/core/constants/env_constants.dart   # API_BASE_URL (--dart-define)
```

New config/deps:
- Build passes `--dart-define=API_BASE_URL=https://blood-backend-dz.onrender.com/api/v1`.
- Add `flutter_secure_storage` for JWT persistence (O1).

---

## 6. Code style & conventions (repo rules — MANDATORY)

- **No hardcoded literals in views** (CLAUDE.md). New strings → `string_manager.dart`
  + `ar.json`/`en.json`; sizes → `values_manager.dart`; colors → `color_manager.dart`;
  **API paths → `rest_paths.dart`**, never inline in a data source.
- Clean Architecture layering unchanged: only `lib/backend/**` and DI wiring import dio.
- Errors: every Dio failure → typed `Failure` via `RestErrorMapper`, carried as
  `Either<Failure, T>` (dartz), rendered as `FlowState` (`/flutter-error-handling`).
- Each implemented method mirrors the Supabase equivalent's Model output exactly
  (same `fromJson`), so no repository/usecase/bloc changes.

---

## 7. Testing strategy

The three-tier migration test net (usecase / slice-integration / datasource) must
stay green — it is the safety harness for exactly this swap.

- **Data-source unit tests**: mock Dio; assert method+path+body and that JSON→Model
  matches the Supabase source output. RED against the stub, GREEN on implement (`/tdd`).
- **Contract smoke** (opt-in, not CI — free-plan cold start ~50s): hit `/config/`
  and `/auth/login/` to catch schema drift.
- **Regression**: full `flutter test` after each feature slice; no net decrease.
- **Manual**: walk each migrated flow against the live API before flipping the next feature.

---

## 8. Boundaries

**Always**
- Keep the abstract-data-source seam; backend SDKs only under `lib/backend/<name>/`.
- Map to existing Models; confirm every field against the live schema before writing it.
- Keep tests green per slice; commit per feature (Conventional Commits, no Claude co-author).
- Store JWTs in secure storage; refresh on 401. Run `graphify update .` after edits.

**Ask first**
- Any change to auth/registration UX or `SignupParams` shape.
- Adding/altering a public Model field or a backend endpoint.
- Avatar-upload handling on REST (O3).
- Deleting Supabase code (separate follow-up after full cutover).
- Changing the notification polling interval or badge behavior.

**Never**
- Hardcode literals in view/widget files, or API paths inline in data sources.
- Touch backend (Django) code as part of this migration unless a blocking gap forces it (then Ask first).
- Commit secrets or the live `.env`; base URL comes via `--dart-define`.

---

## 9. Out of scope (this migration)
- Deleting Supabase data sources / dependency (follow-up).
- New features, UI redesign, backend endpoint additions.
- CI wiring for the live-smoke test.
