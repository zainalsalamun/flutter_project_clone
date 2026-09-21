import '../models/user_account.dart';

abstract class AbcState {}

class AbcInitial extends AbcState {}

class AbcLoading extends AbcState {}

class AbcLoaded extends AbcState {
  final UserAccount account;
  final bool isBalanceVisible;

  AbcLoaded({
    required this.account,
    this.isBalanceVisible = true,
  });

  AbcLoaded copyWith({
    UserAccount? account,
    bool? isBalanceVisible,
  }) {
    return AbcLoaded(
      account: account ?? this.account,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
    );
  }
}

class AbcError extends AbcState {
  final String message;

  AbcError(this.message);
}
