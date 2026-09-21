import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthAppleSignInRequested>(_onAppleSignInRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (event.email.isNotEmpty && event.password.isNotEmpty) {
      emit(AuthAuthenticated(userEmail: event.email, loginMethod: 'Email/Password'));
    } else {
      emit(const AuthError('Please enter both email and password'));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (event.email.isNotEmpty && event.password.isNotEmpty) {
      emit(AuthAuthenticated(userEmail: event.email, loginMethod: 'Registered Email'));
    } else {
      emit(const AuthError('Please enter both email and password'));
    }
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    emit(const AuthAuthenticated(userEmail: 'google_user@gmail.com', loginMethod: 'Google'));
  }

  Future<void> _onAppleSignInRequested(
    AuthAppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    emit(const AuthAuthenticated(userEmail: 'apple_user@icloud.com', loginMethod: 'Apple'));
  }

  void _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthLoading());
    emit(AuthInitial());
  }
}
