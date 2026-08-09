import '../../features/auth/domain/entities/user_entity.dart';

/// In-memory holder for the authenticated user.
///
/// [AuthBloc] is registered as a factory, so a fresh instance is created for
/// every route and its state does not persist across navigations. Screens still
/// need the signed-in user's name for greetings and ownership labels, so the
/// bloc mirrors the current user here where any widget can read it
/// synchronously via the service locator.
class SessionManager {
  UserEntity? _currentUser;

  UserEntity? get currentUser => _currentUser;

  void setUser(UserEntity user) => _currentUser = user;

  void clear() => _currentUser = null;
}
