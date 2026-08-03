part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final String userName;
  final double balance;
  final String accountNumber;
  final bool isBalanceVisible;

  const DashboardLoaded({
    required this.userName,
    required this.balance,
    required this.accountNumber,
    this.isBalanceVisible = true,
  });

  DashboardLoaded copyWith({
    String? userName,
    double? balance,
    String? accountNumber,
    bool? isBalanceVisible,
  }) {
    return DashboardLoaded(
      userName: userName ?? this.userName,
      balance: balance ?? this.balance,
      accountNumber: accountNumber ?? this.accountNumber,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
    );
  }

  @override
  List<Object?> get props => [userName, balance, accountNumber, isBalanceVisible];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
