import 'app_user.dart';

enum AuthStatus { anonymous, authenticated }

/// Session state shared by every feature. `user` may be null while
/// authenticated when `/auth/me` could not be loaded (e.g. offline at launch).
class AuthState {
  const AuthState._({required this.status, this.user});

  const AuthState.anonymous() : this._(status: AuthStatus.anonymous);

  const AuthState.authenticated(AppUser? user) : this._(status: AuthStatus.authenticated, user: user);

  final AuthStatus status;
  final AppUser? user;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  bool get isPhoneVerified => user?.phoneVerified ?? false;

  AuthState copyWith({AppUser? user}) => AuthState._(status: status, user: user ?? this.user);
}
