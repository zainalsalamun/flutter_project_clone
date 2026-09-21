import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userEmail;
  final String loginMethod; // e.g. "Email", "Google", "Apple"

  const AuthAuthenticated({required this.userEmail, required this.loginMethod});

  @override
  List<Object> get props => [userEmail, loginMethod];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
