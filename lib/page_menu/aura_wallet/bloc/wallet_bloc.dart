import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';
import '../models/crypto_asset.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitial()) {
    on<LoadWalletData>(_onLoadWalletData);
    on<RefreshWalletData>(_onRefreshWalletData);
  }

  Future<void> _onLoadWalletData(LoadWalletData event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    await Future.delayed(const Duration(seconds: 2)); // Simulate network request
    
    final assets = _getMockAssets();
    final totalBalance = assets.fold(0.0, (sum, item) => sum + item.totalValue);
    
    emit(WalletLoaded(totalBalance: totalBalance, assets: assets));
  }

  Future<void> _onRefreshWalletData(RefreshWalletData event, Emitter<WalletState> emit) async {
    if (state is! WalletLoaded) emit(WalletLoading());
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate fast refresh
    
    final assets = _getMockAssets();
    // Simulate slight price changes on refresh
    final updatedAssets = assets.map((a) {
      return CryptoAsset(
        id: a.id,
        symbol: a.symbol,
        name: a.name,
        currentPrice: a.currentPrice + (a.currentPrice * 0.01), // +1%
        priceChangePercentage24h: a.priceChangePercentage24h + 1.0,
        balance: a.balance,
        themeColor: a.themeColor,
        icon: a.icon,
      );
    }).toList();
    
    final totalBalance = updatedAssets.fold(0.0, (sum, item) => sum + item.totalValue);
    
    emit(WalletLoaded(totalBalance: totalBalance, assets: updatedAssets));
  }

  List<CryptoAsset> _getMockAssets() {
    return [
      CryptoAsset(
        id: '1',
        symbol: 'BTC',
        name: 'Bitcoin',
        currentPrice: 64230.50,
        priceChangePercentage24h: 2.5,
        balance: 0.15,
        themeColor: const Color(0xFFF7931A),
        icon: Icons.currency_bitcoin,
      ),
      CryptoAsset(
        id: '2',
        symbol: 'ETH',
        name: 'Ethereum',
        currentPrice: 3450.20,
        priceChangePercentage24h: -1.2,
        balance: 2.4,
        themeColor: const Color(0xFF627EEA),
        icon: Icons.currency_exchange,
      ),
      CryptoAsset(
        id: '3',
        symbol: 'SOL',
        name: 'Solana',
        currentPrice: 145.80,
        priceChangePercentage24h: 5.7,
        balance: 45.0,
        themeColor: const Color(0xFF14F195),
        icon: Icons.bolt,
      ),
    ];
  }
}
