import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/iphone_duo_app/models/lock_plan.dart';
import 'package:project_clone/page_menu/iphone_duo_app/widgets/iphone_duo_frame.dart';
import 'package:project_clone/page_menu/iphone_duo_app/widgets/rules_card_widget.dart';
import 'package:project_clone/page_menu/iphone_duo_app/widgets/side_action_dock.dart';

enum ViewMode {
  mockupSwipe,
  trioShowcase,
  fullScreen,
}

class IPhoneDuoHomePage extends StatefulWidget {
  const IPhoneDuoHomePage({super.key});

  @override
  State<IPhoneDuoHomePage> createState() => _IPhoneDuoHomePageState();
}

class _IPhoneDuoHomePageState extends State<IPhoneDuoHomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPageIndex = 0;
  int _selectedNavIndex = 0;
  ViewMode _viewMode = ViewMode.mockupSwipe;

  final List<LockPlan> _plans = LockPlan.samplePlans;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showDepositModal(LockPlan plan) {
    double depositAmount = 100000;
    int selectedDurationMonths = 6;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            double estimatedReturn =
                depositAmount * (0.12 * (selectedDurationMonths / 12.0));
            double totalPayout = depositAmount + estimatedReturn;

            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: plan.lightBgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_clock_rounded,
                          color: plan.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create ${plan.title}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Earn 12% annual interest yield',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Lock Amount (₦)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [50000.0, 100000.0, 250000.0, 500000.0].map((amt) {
                      final isSelected = depositAmount == amt;
                      return ChoiceChip(
                        label: Text('₦${amt.toStringAsFixed(0)}'),
                        selected: isSelected,
                        selectedColor: plan.primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              depositAmount = amt;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Lock Duration',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [3, 6, 12].map((months) {
                      final isSelected = selectedDurationMonths == months;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? plan.lightBgColor
                                  : Colors.transparent,
                              side: BorderSide(
                                color: isSelected
                                    ? plan.primaryColor
                                    : Colors.grey.shade300,
                                width: isSelected ? 1.5 : 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setModalState(() {
                                selectedDurationMonths = months;
                              });
                            },
                            child: Text(
                              '$months Months',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? plan.textColor
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Yield Summary Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Estimated Interest Yield',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              '+₦${estimatedReturn.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: plan.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Payout at Maturity',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              '₦${totalPayout.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: plan.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: plan.primaryColor,
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              '🎉 Successfully locked ₦${depositAmount.toStringAsFixed(0)} in ${plan.title}!',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Confirm & Lock Funds',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNotificationSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.notifications_active, color: Color(0xFF28A0F6)),
                  SizedBox(width: 8),
                  Text(
                    'Notifications',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEAF5FE),
                  child: Icon(Icons.percent, color: Color(0xFF28A0F6)),
                ),
                title: const Text('Interest Credited'),
                subtitle: const Text('Daily 12% APY accrued to your vault.'),
                trailing: const Text('2h ago', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showShareSheet() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔗 Savings plan invite link copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'iPhone Duo • Savings UI',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<ViewMode>(
            icon: const Icon(Icons.devices_other_rounded, color: Colors.black87),
            tooltip: 'Switch Device View',
            initialValue: _viewMode,
            onSelected: (mode) {
              setState(() {
                _viewMode = mode;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ViewMode.mockupSwipe,
                child: Row(
                  children: [
                    Icon(Icons.view_carousel_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Device Swipe View'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ViewMode.trioShowcase,
                child: Row(
                  children: [
                    Icon(Icons.view_column_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Trio Duo Showcase (Side by Side)'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ViewMode.fullScreen,
                child: Row(
                  children: [
                    Icon(Icons.fullscreen_rounded, size: 20),
                    SizedBox(width: 8),
                    Text('Full Screen App Mode'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Mode Indicator Tabs
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _modeButton(
                    title: 'Vault Lock',
                    index: 0,
                    color: const Color(0xFF28A0F6),
                  ),
                  _modeButton(
                    title: 'Fixed Lock',
                    index: 1,
                    color: const Color(0xFF9042F6),
                  ),
                  _modeButton(
                    title: 'Target Savings',
                    index: 2,
                    color: const Color(0xFF1ECB6B),
                  ),
                ],
              ),
            ),

            // Content Area based on View Mode
            Expanded(
              child: _buildBodyContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeButton({
    required String title,
    required int index,
    required Color color,
  }) {
    final isSelected = _currentPageIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPageIndex = index;
        });
        if (_viewMode == ViewMode.mockupSwipe && _pageController.hasClients) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    switch (_viewMode) {
      case ViewMode.mockupSwipe:
        return PageView.builder(
          controller: _pageController,
          itemCount: _plans.length,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final plan = _plans[index];
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: IPhoneDuoDeviceFrame(
                      plan: plan,
                      selectedNavIndex: _selectedNavIndex,
                      onNavItemSelected: (navIdx) {
                        setState(() {
                          _selectedNavIndex = navIdx;
                        });
                      },
                      onBackTap: () => Navigator.maybePop(context),
                      onNotificationTap: _showNotificationSheet,
                      onShareTap: _showShareSheet,
                      onDeposit: () => _showDepositModal(plan),
                      width: 325,
                      height: 620,
                    ),
                  ),
                );
              },
            );
          },
        );

      case ViewMode.trioShowcase:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: _plans.map((plan) {
              return Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IPhoneDuoDeviceFrame(
                  plan: plan,
                  selectedNavIndex: _selectedNavIndex,
                  onNavItemSelected: (navIdx) {
                    setState(() {
                      _selectedNavIndex = navIdx;
                    });
                  },
                  onBackTap: () => Navigator.maybePop(context),
                  onNotificationTap: _showNotificationSheet,
                  onShareTap: _showShareSheet,
                  onDeposit: () => _showDepositModal(plan),
                  width: 310,
                  height: 600,
                ),
              );
            }).toList(),
          ),
        );

      case ViewMode.fullScreen:
        final currentPlan = _plans[_currentPageIndex];
        return Container(
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: LockCardView(
                  plan: currentPlan,
                  onBack: () => Navigator.maybePop(context),
                  onDeposit: () => _showDepositModal(currentPlan),
                ),
              ),
              Container(
                width: 1,
                height: double.infinity,
                color: Colors.grey.withValues(alpha: 0.12),
              ),
              SideActionDock(
                selectedNavIndex: _selectedNavIndex,
                onNavItemSelected: (navIdx) {
                  setState(() {
                    _selectedNavIndex = navIdx;
                  });
                },
                onBackTap: () => Navigator.maybePop(context),
                onNotificationTap: _showNotificationSheet,
                onShareTap: _showShareSheet,
              ),
            ],
          ),
        );
    }
  }
}
