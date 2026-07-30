# DOX — Project Agent Contract

> **tabara3** — Flutter donation/charity app (Arabic: "تبرع"). Clean Architecture + BLoC + get_it DI.

## Core Contract
- One concern per commit; branch first if on default branch.
- Follow existing code style; make minimal, surgical changes.
- Update this file when conventions change; delete stale text.
- **Zero AI footprint**: commits, PRs, and issue comments must read as human-authored. Never mention AI tools (Claude, Copilot, ChatGPT, Cursor, etc.), never add `Co-Authored-By` trailers, never reference agent sessions or prompts.

## Read Before Editing
- Read this file and any child `AGENTS.md` on the path to your target file.
- Nearest doc controls local details; no child may weaken this contract.
- Read `CLAUDE.md` for Flutter skill auto-load rules and memory protocol.

## Update After Editing
- Update the closest owning `AGENTS.md` (and parents/children + Child DOX Index) when purpose, scope, ownership, structure, contracts, workflows, I/O, constraints, or user preferences change.
- After ANY code modification: run `graphify update .` before declaring task done.
- Run `flutter analyze` before declaring work complete; fix all warnings.

## Hierarchy
- Root: this file
- Child DOX Index: not yet indexed

## Style
- Conventional Commits (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`).
- Dart formatting: `dart format .` — follow `analysis_options.yaml` lint rules.
- No comments unless asked. No emojis in code.
- Prefer `const` constructors. Use `equatable` for BLoC states/events. Use `freezed` for data models/DTOs (immutable + generated fromJson/toJson).

## No Hardcoded Values in Views (MANDATORY)
- **Never** put literal strings, ints, or doubles inside presentation/pages or widgets. No magic numbers, no inline text, no raw hex colors.
- Centralize every literal in dedicated files under `lib/core/`:
  - UI text / labels / messages → `lib/core/utils/string_manager.dart` (`AppStrings` constants) + translation JSONs (`assets/translations/ar.json`, `en.json`). Views use `AppStrings.xxx.tr()`.
  - Sizes, spacing, radii, durations → `lib/core/constants/app_dimensions.dart`.
  - Colors → theme / `lib/core/theme/app_colors.dart` (never inline `Color(0x...)` in a page).
  - Keys, routes, API paths, config → their own `lib/core/constants/` files.
- Views reference the constant, never the literal. One source of truth per value.
- Applies to all `presentation/pages/` and widget files. Enum-like fixed sets go in domain, not the view.
- **Adding a new UI string:** add key to `AppStrings` in `string_manager.dart`, add Arabic value to `ar.json`, add English value to `en.json`, then use `AppStrings.key.tr()` in the view. Never skip the translation files.

## Arabic Text Direction (MANDATORY)
- Arabic text must always render RIGHT-TO-LEFT (RTL). Never write Arabic content in a left-to-right order that forces the reader to read it backwards.
- All screens wrapping Arabic content must use `Directionality(textDirection: TextDirection.rtl, ...)`.
- When using `Row`, `Column`, or `Text` with Arabic, verify the visual order is correct: the first widget/text in code appears on the RIGHT side in RTL.
- `textAlign: TextAlign.right` for Arabic paragraphs. `CrossAxisAlignment.end` in LTR rows maps to the right side.
- If a string looks "backwards" or "reversed" on screen, the issue is missing RTL wrapping — do NOT reverse the string characters. Fix the directionality, never the text.

## Architecture — Clean Architecture (3 layers) + BLoC

### Dependency rule
Data → Domain ← Presentation. Domain depends on nothing. Data implements domain interfaces. Presentation consumes domain via usecases.

### Logout flow
- Dialog: `lib/core/presentation/widgets/logout_dialog.dart` (Figma: warning icon, two stacked 174px buttons — red `تسجيل الخروج` primary, gray `إلغاء` secondary).
- Dispatch: profile screen calls `context.read<AuthBloc>().add(SignOutRequested())`; the AuthBloc in turn calls `client.auth.signOut()` (Supabase session invalidated — next launch must log in again).
- Navigation: `DonorHomeScreen` / `RequesterHomeScreen` wrap themselves in `BlocListener<AuthBloc>` (`listenWhen: Unauthenticated`) and push to `Routes.welcomeRoute` with `pushAndRemoveUntil`.
- `AuthBloc` is provided via the route manager for `/donor-home` and `/requester-home`; direct `MaterialPageRoute` to those screens skips the provider and breaks the listener.

### Folder structure (per feature)
```
lib/features/<feature>/
  data/
    datasources/     # remote + local data sources
    models/          # JSON DTOs (freezed + json_annotation, generated .g.dart/.freezed.dart)
    repositories/    # repository implementations
  domain/
    entities/        # pure domain models (no Flutter/JSON deps)
    repositories/    # abstract repository interfaces
    usecases/        # single-purpose use cases (call repository)
  presentation/
    pages/           # Screen widgets
    bloc/            # BLoC: events, states, bloc (flutter_bloc)
```
- `lib/core/` — shared: error/failures, usecases base, constants, theme, utils.
- `lib/injection_container.dart` — get_it service locator; register per-feature in `init<Feature>()` functions.
- `lib/main.dart` — entry point; calls `di.init()` then runs `MyApp`.

### State management
- `flutter_bloc` (Cubit/BLoC) with `equatable` states. Emit typed states; no dynamic.
- `dartz` `Either<Failure, T>` from repository → usecase → bloc catches and maps to bloc states.

### Error handling
- `lib/core/error/failures.dart` — typed `Failure` classes. Repositories return `Left(failure)` on error.
- Map network/exceptions to `Failure` subtypes at the data boundary.

## Tech Stack
- Flutter SDK ^3.8.1, Material 3
- State: `flutter_bloc` ^9.0.0, `equatable` ^2.0.7
- DI: `get_it` ^8.0.2
- FP: `dartz` ^0.10.1
- Routing: `go_router` ^14.8.1 (declarative routing, no Navigator 1.0 push/pop)
- Serialization: `freezed` ^2.5.8 + `json_annotation` ^4.9.0 (generated fromJson/toJson via build_runner)
- Styling: `google_fonts` (Cairo), `flutter_svg`
- Linting: `flutter_lints` ^5.0.0, `analysis_options.yaml`

## Theme
- Primary: `#8B1D1D` (dark red), Secondary: `#4CAF50` (green), Background: white, Surface: `#F5F5F5`.
- Font: Google Fonts Cairo (Arabic-supportive). App is RTL-ready (Arabic UI).

## Features
| Feature | Path | Purpose |
|---------|------|---------|
| splash | `features/splash/` | Splash screen entry |
| auth | `features/auth/` | Login, signup, role selection (donor/requester) |
| requester_home | `features/requester_home/` | Recipient dashboard, request lifecycle, invitations, and expiring request QR |
| donor_home | `features/donor_home/` | Donor dashboard, compatible requests, campaigns, appointments, QR redemption, card, and records |
| notifications | `features/notifications/` | RLS-backed notification center and read-state updates |
| profile | `features/profile/` | Profile views (donor + requester) |
| counter | `features/counter/` | Template/scaffold feature (Clean Arch reference) |

## graphify
- If `graphify-out/graph.json` exists: use `graphify query` / `path` / `explain` before grep/file reads.
- If it does not exist: run `graphify update .` before substantial exploration.
- After any code modification: run `graphify update .` (AST-only, no API cost).

## Supabase
- Project: `nzsaghjwyitjhyagdbjb` (Tabara3)
- URL: `https://nzsaghjwyitjhyagdbjb.supabase.co`
- Publishable key: `sb_publishable_1n_-1Jz7yiiERq3odEIPOg_0eKi2ly1`
- Config: `.env` (SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY), loaded via `String.fromEnvironment`
- Use RLS policies on every table. Use migrations for DDL; `execute_sql` for DML/debug.
- Profile creation: `handle_new_user()` trigger on `auth.users` INSERT populates `public.users` from `raw_user_meta_data` (migration 00003).

## Memory (MANDATORY — run FIRST every session)
1. **claude-mem** — `/recall` or `mcp__claude-mem__*` search → prior session actions (files, commands, edits).
2. **agentmemory** — `mcp__agentmemory__memory_recall` → decisions, preferences, architecture.
3. `memory/MEMORY.md` → stable project facts (auto-loaded).
4. Only after all three: grep / read / explore.

Save to agentmemory immediately when a decision/preference is stated. One fact per save, include why.

## Issue Tracker
GitHub Issues: `github.com/Mouaadmoudraa/tabara3`. See `docs/agents/issue-tracker.md`.
Triage labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.
Domain docs: `CONTEXT.md` + `docs/adr/` at repo root. See `docs/agents/domain.md`.

## TDD — Test-Driven Development (MANDATORY)

**Tests first, code second. Never skip this.**

### The cycle
1. **Red** — write a failing test that defines the expected behavior.
2. **Green** — write the minimum code to make the test pass.
3. **Refactor** — clean up code while keeping tests green.

### Rules
- **No implementation code without a test.** Every repository, usecase, BLoC, datasource, and model must have tests written first.
- **Tests define the contract.** If you can't write a test, the interface is wrong.
- **Test in isolation.** Domain tests are pure Dart (no Flutter). Data layer tests mock external dependencies. Presentation tests use `bloc_test` and `WidgetTester`.
- **Never skip tests for "simple" code.** Simple code becomes complex; tests catch regressions.

### Test types and where they live
| Type | Location | Scope |
|------|----------|-------|
| Unit | `test/unit/` | Domain entities, usecases (pure Dart, no Flutter) |
| BLoC | `test/unit/` | Events → States via `bloc_test` |
| Data | `test/unit/` | Repositories, datasources, models (mock dependencies) |
| Widget | `test/widget/` | UI rendering + interactions via `WidgetTester` |
| Integration | `test/integration/` | Full feature flows |

### Test file naming
```
test/
  unit/
    features/<feature>/domain/usecases/<usecase>_test.dart
    features/<feature>/data/repositories/<repo>_impl_test.dart
    features/<feature>/presentation/bloc/<bloc>_test.dart
  widget/
    features/<feature>/presentation/pages/<page>_test.dart
  integration/
    features/<feature>/<flow>_test.dart
```

### Red-green workflow per feature
```
1. Write domain entity test → implement entity
2. Write repository interface test → implement interface
3. Write usecase test → implement usecase
4. Write datasource test → implement datasource
5. Write repository impl test → implement repository impl
6. Write BLoC test → implement BLoC
7. Write widget test → implement page
```

### Before commit
- All existing tests pass (`flutter test`)
- New code has tests (red→green→refactor cycle completed)
- Run `flutter test --coverage` — no drop in coverage

## Verification
- `flutter analyze` — must pass with zero errors before commit.
- `flutter test` — must pass with all tests green; new code requires tests first.
- `flutter test --coverage` — coverage must not decrease.
- `dart format .` — ensure formatting before commit.
