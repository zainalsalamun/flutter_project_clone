import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_text_styles.dart';
import '../../bloc/dashboard_bloc.dart';
import '../widgets/hero_card.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/recent_transaction_list.dart';
// import '../widgets/recent_transaction_list.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(LoadDashboardData()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardError) {
              return Center(child: Text(state.message));
            } else if (state is DashboardLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(LoadDashboardData());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Pagi',
                                style: AppTextStyles.caption,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${state.userName} 👋',
                                style: AppTextStyles.heading,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Hero Card
                      HeroCard(
                        balance: state.balance,
                        accountNumber: state.accountNumber,
                        isBalanceVisible: state.isBalanceVisible,
                        onToggleVisibility: () {
                          context.read<DashboardBloc>().add(ToggleBalanceVisibility());
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Quick Actions
                      const QuickActionGrid(),
                      
                      const SizedBox(height: 24),
                      
                      // Promo Banner
                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.secondary, Color(0xFF1E293B)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Promo Spesial',
                                    style: AppTextStyles.heading.copyWith(color: Colors.white, fontSize: 18),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Diskon hingga 50%',
                                    style: AppTextStyles.caption.copyWith(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Lihat Semua',
                                style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Recent Transactions
                      const RecentTransactionList(),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
