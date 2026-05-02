import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/storage_service.dart';

// ── Credentials ────────────────────────────────────────────────────────────────
// Single valid user — replace with real auth endpoint in production.
const String _validEmail = 'manager@silk.farm';
const String _validPassword = 'silk1234';

// ── Auth state ─────────────────────────────────────────────────────────────────

/// Represents every possible auth state the app can be in.
sealed class AuthState {
  const AuthState();
}

/// No session — user must log in.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Credentials are being validated.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Session is active. [email] is the logged-in user's email.
final class AuthAuthenticated extends AuthState {
  final String email;
  const AuthAuthenticated(this.email);
}

/// Login failed. [message] is the user-facing error text.
final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// ── Notifier ───────────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthUnauthenticated()) {
    _restoreSession();
  }

  /// Called in [AuthNotifier()] — restores session from SharedPreferences.
  /// If a stored email is found, transitions directly to [AuthAuthenticated]
  /// so the app skips the login screen on relaunch.
  void _restoreSession() {
    final saved = StorageService.instance.getUser();
    if (saved != null && saved.isNotEmpty) {
      state = AuthAuthenticated(saved);
    }
  }

  /// Validates [email] and [password] against the hardcoded credential pair.
  ///
  /// Transitions: Unauthenticated/Error → Loading → Authenticated | Error
  Future<void> login(String email, String password) async {
    state = const AuthLoading();

    // Simulate a short async validation delay for realistic UX.
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final trimmedEmail = email.trim().toLowerCase();
    final trimmedPassword = password.trim();

    if (trimmedEmail == _validEmail && trimmedPassword == _validPassword) {
      await StorageService.instance.saveUser(trimmedEmail);
      state = AuthAuthenticated(trimmedEmail);
    } else {
      state = const AuthError('Invalid email or password. Please try again.');
    }
  }

  /// Clears the stored session and returns to unauthenticated state.
  Future<void> logout() async {
    await StorageService.instance.clearUser();
    state = const AuthUnauthenticated();
  }
}

// ── Provider ───────────────────────────────────────────────────────────────────

/// Global auth provider. Watched by [LoginScreen] and [MainShell].
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
