import '../models/crypto_asset.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final double totalBalance;
  final List<CryptoAsset> assets;

  WalletLoaded({required this.totalBalance, required this.assets});
}

class WalletError extends WalletState {
  final String message;

  WalletError(this.message);
}
