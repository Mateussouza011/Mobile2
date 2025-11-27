import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/admin_metrics_provider.dart';
import '../../domain/entities/admin_metrics_stats.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminMetricsProvider>().loadAllMetrics();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard do Sistema'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Visão Geral', icon: Icon(Icons.dashboard, size: 18)),
            Tab(text: 'Receita', icon: Icon(Icons.attach_money, size: 18)),
            Tab(text: 'Crescimento', icon: Icon(Icons.trending_up, size: 18)),
            Tab(text: 'Saúde', icon: Icon(Icons.health_and_safety, size: 18)),
          ],
        ),
        actions: [
          Consumer<AdminMetricsProvider>(
            builder: (context, provider, _) {
              if (provider.lastUpdated != null) {
                final timeAgo = _getTimeAgo(provider.lastUpdated!);
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      'Atualizado $timeAgo',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AdminMetricsProvider>().refresh(),
          ),
        ],
      ),
      body: Consumer<AdminMetricsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && !provider.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.refresh(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (!provider.hasData) {
            return const Center(child: Text('Nenhum dado disponível'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(context, provider),
                _buildRevenueTab(context, provider),
                _buildGrowthTab(context, provider),
                _buildHealthTab(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==================== OVERVIEW TAB ====================
  
  Widget _buildOverviewTab(BuildContext context, AdminMetricsProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Summary Cards
        _buildSummaryCards(context, provider),
        const SizedBox(height: 24),
        
        // Tier Distribution
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distribuição de Planos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                if (provider.tierDistribution != null)
                  SizedBox(
                    height: 250,
                    child: _buildTierPieChart(provider.tierDistribution!),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Quick Stats Grid
        _buildQuickStatsGrid(context, provider),
      ],
    );
  }

  Widget _buildSummaryCards(BuildContext context, AdminMetricsProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSummaryCard(
            context,
            title: 'Usuários',
            value: provider.totalUsers.toString(),
            subtitle: '${provider.activeUsers} ativos',
            icon: Icons.people,
            color: Colors.blue,
            trend: provider.userGrowth,
          ),
          const SizedBox(width: 12),
          _buildSummaryCard(
            context,
            title: 'Empresas',
            value: provider.totalCompanies.toString(),
            subtitle: 'Total cadastradas',
            icon: Icons.business,
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          _buildSummaryCard(
            context,
            title: 'MRR',
            value: _formatCurrency(provider.mrr),
            subtitle: 'Receita mensal',
            icon: Icons.attach_money,
            color: Colors.green,
            trend: provider.revenueGrowth,
          ),
          const SizedBox(width: 12),
          _buildSummaryCard(
            context,
            title: 'Saúde',
            value: '${provider.healthScore.toStringAsFixed(0)}%',
            subtitle: _getHealthLabel(provider.healthScore),
            icon: Icons.favorite,
            color: _getHealthColor(provider.healthScore),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    double? trend,
  }) {
    return Card(
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                if (trend != null) _buildTrendIndicator(trend),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(double trend) {
    final isPositive = trend >= 0;
    final color = isPositive ? Colors.green : Colors.red;
    final icon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;
    
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        Text(
          '${trend.abs().toStringAsFixed(1)}%',
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildQuickStatsGrid(BuildContext context, AdminMetricsProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'ARPU',
                _formatCurrency(provider.arpu),
                'Receita média por usuário',
                Icons.person_outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                'Receita Total',
                _formatCurrency(provider.totalRevenue),
                'Receita acumulada',
                Icons.account_balance_wallet,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Previsões',
                provider.systemMetrics?.totalPredictions.toString() ?? '0',
                'Total de previsões',
                Icons.analytics,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                'API Calls',
                provider.systemMetrics?.totalApiCalls.toString() ?? '0',
                'Chamadas de API',
                Icons.api,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== REVENUE TAB ====================
  
  Widget _buildRevenueTab(BuildContext context, AdminMetricsProvider provider) {
    if (provider.revenueMetrics == null) {
      return const Center(child: Text('Dados de receita não disponíveis'));
    }

    final metrics = provider.revenueMetrics!;
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Revenue Growth
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Receita Mensal',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    _buildTrendIndicator(metrics.revenueGrowthRate),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250,
                  child: _buildRevenueLineChart(metrics.monthlyRevenue),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Daily Revenue
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receita Diária (Últimos 30 dias)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: _buildRevenueBarChart(metrics.dailyRevenue),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // MRR History
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Histórico de MRR',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: _buildMRRLineChart(metrics.mrrHistory),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== GROWTH TAB ====================
  
  Widget _buildGrowthTab(BuildContext context, AdminMetricsProvider provider) {
    if (provider.userGrowthMetrics == null || provider.usageMetrics == null) {
      return const Center(child: Text('Dados de crescimento não disponíveis'));
    }

    final userMetrics = provider.userGrowthMetrics!;
    final usageMetrics = provider.usageMetrics!;
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // User Signups
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Novos Usuários',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    _buildTrendIndicator(userMetrics.signupGrowthRate),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250,
                  child: _buildUserGrowthChart(userMetrics.monthlySignups),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Usage Growth
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Uso de Previsões',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    _buildTrendIndicator(usageMetrics.predictionsGrowthRate),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: _buildUsageLineChart(usageMetrics.dailyPredictions),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Top Users/Companies
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTopList(
                context,
                'Top Empresas',
                usageMetrics.predictionsByCompany,
                Icons.business,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTopList(
                context,
                'Top Usuários',
                usageMetrics.predictionsByUser,
                Icons.person,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopList(
    BuildContext context,
    String title,
    Map<String, int> data,
    IconData icon,
  ) {
    final sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...sortedEntries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    entry.value.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  // ==================== HEALTH TAB ====================
  
  Widget _buildHealthTab(BuildContext context, AdminMetricsProvider provider) {
    if (provider.healthMetrics == null) {
      return const Center(child: Text('Dados de saúde não disponíveis'));
    }

    final metrics = provider.healthMetrics!;
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Health Score Cards
        Row(
          children: [
            Expanded(
              child: _buildHealthCard(
                context,
                'Saúde Geral',
                metrics.overallHealth,
                Icons.health_and_safety,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHealthCard(
                context,
                'Pagamentos',
                metrics.paymentHealth,
                Icons.payment,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildHealthCard(
                context,
                'Engagement',
                metrics.userEngagement,
                Icons.people,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHealthCard(
                context,
                'Assinaturas',
                metrics.subscriptionHealth,
                Icons.subscriptions,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Alerts
        if (metrics.alerts.isNotEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'Alertas do Sistema',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      if (metrics.criticalIssues > 0)
                        Chip(
                          label: Text('${metrics.criticalIssues} críticos'),
                          backgroundColor: Colors.red[100],
                          labelStyle: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...metrics.alerts.map((alert) => _buildAlertTile(context, alert)),
                ],
              ),
            ),
          ),
        ] else ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, size: 48, color: Colors.green),
                    const SizedBox(height: 8),
                    Text(
                      'Nenhum alerta no momento',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Todos os sistemas estão operando normalmente',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHealthCard(
    BuildContext context,
    String title,
    double score,
    IconData icon,
  ) {
    final color = _getHealthColor(score);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              '${score.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertTile(BuildContext context, HealthAlert alert) {
    Color color;
    IconData icon;
    
    switch (alert.severity) {
      case HealthAlertSeverity.critical:
        color = Colors.red;
        icon = Icons.error;
        break;
      case HealthAlertSeverity.warning:
        color = Colors.orange;
        icon = Icons.warning;
        break;
      case HealthAlertSeverity.info:
        color = Colors.blue;
        icon = Icons.info;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(alert.message),
        subtitle: Text(alert.details),
        trailing: Text(
          _formatDate(alert.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  // ==================== CHARTS ====================
  
  Widget _buildTierPieChart(TierDistribution distribution) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.grey,
            value: distribution.freePercentage,
            title: 'Free\n${distribution.freePercentage.toStringAsFixed(1)}%',
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Colors.blue,
            value: distribution.proPercentage,
            title: 'Pro\n${distribution.proPercentage.toStringAsFixed(1)}%',
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Colors.purple,
            value: distribution.enterprisePercentage,
            title: 'Enterprise\n${distribution.enterprisePercentage.toStringAsFixed(1)}%',
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildRevenueLineChart(List<TimeSeriesData> data) {
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= data.length) return const Text('');
                final date = data[value.toInt()].date;
                return Text(
                  DateFormat('MM/yy').format(date),
                  style: const TextStyle(fontSize: 10),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatCurrencyShort(value),
                  style: const TextStyle(fontSize: 10),
                );
              },
              reservedSize: 50,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueBarChart(List<TimeSeriesData> data) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.value,
                color: Colors.green,
                width: 8,
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatCurrencyShort(value),
                  style: const TextStyle(fontSize: 10),
                );
              },
              reservedSize: 50,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }

  Widget _buildMRRLineChart(List<TimeSeriesData> data) {
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= data.length) return const Text('');
                return Text(
                  data[value.toInt()].label ?? '',
                  style: const TextStyle(fontSize: 10),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  _formatCurrencyShort(value),
                  style: const TextStyle(fontSize: 10),
                );
              },
              reservedSize: 50,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserGrowthChart(List<TimeSeriesData> data) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.value,
                color: Colors.blue,
                width: 12,
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= data.length) return const Text('');
                return Text(
                  data[value.toInt()].label ?? '',
                  style: const TextStyle(fontSize: 10),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }

  Widget _buildUsageLineChart(List<TimeSeriesData> data) {
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.orange.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== HELPERS ====================
  
  String _formatCurrency(double value) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
  }

  String _formatCurrencyShort(double value) {
    if (value >= 1000000) {
      return 'R\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return 'R\$${(value / 1000).toStringAsFixed(1)}K';
    }
    return 'R\$${value.toStringAsFixed(0)}';
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yy HH:mm').format(date);
  }

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'há ${diff.inHours}h';
    return 'há ${diff.inDays}d';
  }

  Color _getHealthColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getHealthLabel(double score) {
    if (score >= 80) return 'Excelente';
    if (score >= 60) return 'Bom';
    if (score >= 40) return 'Regular';
    return 'Crítico';
  }
}
