import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// --- Events ---
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class AppStarted extends AuthEvent {}
class LoggedIn extends AuthEvent {
  final String token;
  LoggedIn(this.token);
  @override
  List<Object?> get props => [token];
}
class LoggedOut extends AuthEvent {}

// --- States ---
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final String token;
  AuthAuthenticated(this.token);
  @override
  List<Object?> get props => [token];
}
class AuthUnauthenticated extends AuthState {}

// --- Bloc ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  static const String _tokenKey = 'jwt_token';

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await secureStorage.read(key: _tokenKey);
        if (token != null) {
          emit(AuthAuthenticated(token));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (_) {
        emit(AuthUnauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthLoading());
      await secureStorage.write(key: _tokenKey, value: event.token);
      emit(AuthAuthenticated(event.token));
    });

    on<LoggedOut>((event, emit) async {
      emit(AuthLoading());
      await secureStorage.delete(key: _tokenKey);
      emit(AuthUnauthenticated());
    });
  }
}
