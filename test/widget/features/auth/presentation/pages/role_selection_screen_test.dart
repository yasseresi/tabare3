import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/core/session/session_manager.dart';
import 'package:tabare3/core/usecases/usecase.dart';
import 'package:tabare3/features/auth/domain/entities/user_entity.dart';
import 'package:tabare3/features/auth/domain/usecases/get_current_session.dart';
import 'package:tabare3/features/auth/domain/usecases/login_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/sign_out.dart';
import 'package:tabare3/features/auth/domain/usecases/signup_with_email_password.dart';
import 'package:tabare3/features/auth/domain/usecases/update_user_role.dart';
import 'package:tabare3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tabare3/features/auth/presentation/pages/role_selection_screen.dart';
import 'package:tabare3/core/utils/color_manager.dart';
import 'package:tabare3/core/utils/font_manager.dart';
import 'package:tabare3/core/utils/route_manager.dart';
import 'package:tabare3/core/utils/values_manager.dart';

import '../../../../../helpers/test_app.dart';

class _MockLogin extends Mock implements LoginWithUsernamePassword {}

class _MockSignup extends Mock implements SignupWithUsernamePassword {}

class _MockSignOut extends Mock implements SignOut {}

class _MockSession extends Mock implements GetCurrentSession {}

class _MockRole extends Mock implements UpdateUserRole {}

class _MockSessionManager extends Mock implements SessionManager {}

void main() {
  final sl = GetIt.instance;

  setUpAll(() async {
    await setupTestLocalization();
    registerFallbackValue(NoParams());
    registerFallbackValue(
      const UpdateRoleParams(isDonor: false, isRecipient: true),
    );
  });

  setUp(() {
    sl.reset();

    sl.registerFactory(
      () => AuthBloc(
        loginWithUsernamePassword: sl(),
        signupWithUsernamePassword: sl(),
        signOutUseCase: sl(),
        getCurrentSession: sl(),
        updateUserRole: sl(),
        sessionManager: sl(),
      ),
    );
    sl.registerLazySingleton<LoginWithUsernamePassword>(() => _MockLogin());
    sl.registerLazySingleton<SignupWithUsernamePassword>(() => _MockSignup());
    sl.registerLazySingleton<SignOut>(() => _MockSignOut());
    sl.registerLazySingleton<GetCurrentSession>(() => _MockSession());
    sl.registerLazySingleton<UpdateUserRole>(() => _MockRole());
    sl.registerLazySingleton<SessionManager>(() => _MockSessionManager());
  });

  testWidgets('shows the Figma-sized confirmation dialog for recipient mode', (
    tester,
  ) async {
    await pumpTestApp(tester, const RoleSelectionScreen());

    expect(find.byType(DecoratedBox), findsWidgets);
    expect(find.byType(Image), findsOneWidget);

    final recipientButton = find.text('أحتاج دم');
    await tester.ensureVisible(recipientButton);
    await tester.tap(recipientButton);
    await tester.pumpAndSettle();

    expect(find.text('تأكيد تحديث الحالة !'), findsOneWidget);
    expect(find.text('إلغاء'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is SizedBox && widget.width == AppSize.s174,
      ),
      findsNWidgets(2),
    );
  });

  testWidgets('renders hadith intro and body at the Figma style', (
    tester,
  ) async {
    await pumpTestApp(tester, const RoleSelectionScreen());

    // Figma 41:5183 — intro + hadith share one style: 20px, medium, #6B7280.
    final hadithText = find.byWidgetPredicate((widget) {
      if (widget is! Text) return false;
      final style = widget.style;
      return style != null &&
          style.fontSize == FontSize.s20 &&
          style.fontWeight == FontWeightManager.medium &&
          style.color == ColorManager.textMuted;
    });

    expect(hadithText, findsNWidgets(2));
  });

  testWidgets(
    'navigates to the donor home named route after selecting donor',
    (tester) async {
      // The donor/requester home routes wrap their screens in the required
      // MultiBlocProvider (AuthBloc + feed bloc). Pushing the screen widgets
      // directly — as the buggy version did — escapes that scope and throws
      // ProviderNotFoundException. Assert we go through the named route.
      const donorUser = UserEntity(
        id: 'u1',
        email: 'd@example.com',
        username: 'donor',
        fullName: 'Donor',
        isDonor: true,
        bloodType: 'A+',
      );
      when(
        () => (sl<UpdateUserRole>() as _MockRole).call(any()),
      ).thenAnswer((_) async => const Right(donorUser));

      String? pushedRoute;

      await pumpTestApp(
        tester,
        const RoleSelectionScreen(),
        onGenerateRoute: (settings) {
          pushedRoute = settings.name;
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const SizedBox.shrink(),
          );
        },
      );

      final donorButton = find.text('أنا متبرع');
      await tester.ensureVisible(donorButton);
      await tester.tap(donorButton);
      await tester.pumpAndSettle();

      expect(pushedRoute, Routes.donorHomeRoute);
    },
  );
}
