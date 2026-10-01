import 'dart:async';
import 'package:flutter/material.dart';
import 'data/ai_dashboard_mock_data.dart';
import 'models/ai_dashboard_models.dart';
import 'theme/ai_dashboard_theme.dart';
import 'widgets/active_agents_table.dart';
import 'widgets/budget_limit_card.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_sidebar.dart';
import 'widgets/deploy_agent_modal.dart';
import 'widgets/global_region_latency_grid.dart';
import 'widgets/kpi_metric_card.dart';
import 'widgets/llm_token_usage_chart.dart';
import 'widgets/model_distribution_donut_chart.dart';

class AiCloudDashboardPage extends StatefulWidget {
  const AiCloudDashboardPage({super.key});

  @override
  State<AiCloudDashboardPage> createState() => _AiCloudDashboardPageState();
}

class _AiCloudDashboardPageState extends State<AiCloudDashboardPage> {
  int _selectedNavIndex = 0;
  bool _isSidebarCollapsed = false;
  String _currentEnvironment = "Production AWS-US";
  bool _isRefreshing = false;

  late List<AiAgentTask> _tasks;
  Timer? _liveTicker;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(AiDashboardMockData.initialTasks);

    // Auto update progress simulation for running agents
    _liveTicker = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _tasks =
              _tasks.map((task) {
                if (task.status == 'Running' && task.progress < 1.0) {
                  final newProgress = (task.progress + 0.04).clamp(0.0, 1.0);
                  return task.copyWith(
                    progress: newProgress,
                    status: newProgress >= 1.0 ? 'Completed' : 'Running',
                  );
                }
                return task;
              }).toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _liveTicker?.cancel();
    super.dispose();
  }

  void _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AiDashboardTheme.success,
                size: 18,
              ),
              SizedBox(width: 8),
              Text("Cluster metrics synchronized in real-time."),
            ],
          ),
          backgroundColor: AiDashboardTheme.surfaceElevated,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _openDeployModal() {
    DeployAgentModal.show(
      context,
      onDeploy: (newTask) {
        setState(() {
          _tasks.insert(0, newTask);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: AiDashboardTheme.background,
      body: Row(
        children: [
          // Collapsible Left Navigation Sidebar (Desktop & Tablet)
          if (!isMobile)
            DashboardSidebar(
              selectedIndex: _selectedNavIndex,
              onItemSelected: (idx) => setState(() => _selectedNavIndex = idx),
              isCollapsed: _isSidebarCollapsed,
              onToggleCollapse:
                  () => setState(
                    () => _isSidebarCollapsed = !_isSidebarCollapsed,
                  ),
            ),

          // Main View Content
          Expanded(
            child: Column(
              children: [
                // Top Global Header
                DashboardHeader(
                  currentEnv: _currentEnvironment,
                  onEnvChanged:
                      (env) => setState(() => _currentEnvironment = env),
                  onNewAgent: _openDeployModal,
                  onRefresh: _handleRefresh,
                  isRefreshing: _isRefreshing,
                ),

                // Scrollable Dashboard Body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 24,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page Banner Title
                        _buildWelcomeBanner(isMobile),
                        const SizedBox(height: 20),

                        // Row 1: KPI Metric Cards
                        _buildKpiSection(screenWidth),
                        const SizedBox(height: 20),

                        // Row 2: Charts (Token Line Chart + Donut Distribution)
                        _buildChartsSection(screenWidth),
                        const SizedBox(height: 20),

                        // Row 3: Edge Latency + Monthly Quota Manager
                        _buildInfrastructureSection(screenWidth),
                        const SizedBox(height: 20),

                        // Row 4: Active Agents Data Table
                        ActiveAgentsTable(
                          tasks: _tasks,
                          onTasksUpdated:
                              (updated) => setState(() => _tasks = updated),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AiDashboardTheme.primary.withOpacity(0.2),
            AiDashboardTheme.surfaceCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AiDashboardTheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: AiDashboardTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_graph_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AI Inference & Cloud Fleet Live Hub",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AiDashboardTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "All 4 Model Backbones operational. 0 throttle bottlenecks detected.",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AiDashboardTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile)
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("📄 Exporting metrics to CSV & PDF..."),
                        backgroundColor: AiDashboardTheme.surfaceElevated,
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AiDashboardTheme.textSecondary,
                    side: const BorderSide(color: AiDashboardTheme.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                  icon: const Icon(Icons.file_download_outlined, size: 16),
                  label: const Text(
                    "Export Report",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildKpiSection(double width) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        int crossAxisCount = 4;
        double childAspectRatio = 2.0;

        if (availableWidth < 650) {
          crossAxisCount = 1;
          childAspectRatio = 3.2;
        } else if (availableWidth < 1080) {
          crossAxisCount = 2;
          childAspectRatio = 2.4;
        } else {
          crossAxisCount = 4;
          childAspectRatio = 2.0;
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: childAspectRatio,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            KpiMetricCard(
              title: "Total Tokens (24H)",
              value: "39.71M",
              changePercentage: "+18.4%",
              isPositive: true,
              subtext: "vs last 24h cycle",
              icon: Icons.data_usage_rounded,
              accentColor: AiDashboardTheme.primaryGlow,
              sparklinePoints: [12, 14, 18, 16, 22, 28, 39],
            ),
            KpiMetricCard(
              title: "Estimated Cost (MTD)",
              value: "\$148.93",
              changePercentage: "-4.2%",
              isPositive: true,
              subtext: "within 59% budget cap",
              icon: Icons.attach_money_rounded,
              accentColor: AiDashboardTheme.success,
              sparklinePoints: [40, 65, 80, 110, 125, 140, 148],
            ),
            KpiMetricCard(
              title: "Avg Inference Latency",
              value: "325 ms",
              changePercentage: "-12.5%",
              isPositive: true,
              subtext: "p99 480ms (Fast)",
              icon: Icons.speed_rounded,
              accentColor: AiDashboardTheme.secondary,
              sparklinePoints: [410, 390, 360, 370, 340, 330, 325],
            ),
            KpiMetricCard(
              title: "Autonomous Agents",
              value: "4 Active",
              changePercentage: "99.8%",
              isPositive: true,
              subtext: "5 tasks queued",
              icon: Icons.smart_toy_rounded,
              accentColor: AiDashboardTheme.accentPurple,
              sparklinePoints: [2, 3, 3, 4, 4, 5, 4],
            ),
          ],
        );
      },
    );
  }

  Widget _buildChartsSection(double width) {
    if (width < 1024) {
      return Column(
        children: const [
          LlmTokenUsageChart(),
          SizedBox(height: 16),
          ModelDistributionDonutChart(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(flex: 7, child: LlmTokenUsageChart()),
        SizedBox(width: 16),
        Expanded(flex: 4, child: ModelDistributionDonutChart()),
      ],
    );
  }

  Widget _buildInfrastructureSection(double width) {
    if (width < 1024) {
      return Column(
        children: const [
          GlobalRegionLatencyGrid(),
          SizedBox(height: 16),
          BudgetLimitCard(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(flex: 6, child: GlobalRegionLatencyGrid()),
        SizedBox(width: 16),
        Expanded(flex: 5, child: BudgetLimitCard()),
      ],
    );
  }
}
