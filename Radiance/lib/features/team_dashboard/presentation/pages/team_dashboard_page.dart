import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/team_dashboard_provider.dart';
import '../../domain/entities/team_stats.dart';
import '../../../../core/theme/radiance_colors.dart';

class TeamDashboardPage extends StatefulWidget {
  const TeamDashboardPage({super.key});

  @override
  State<TeamDashboardPage> createState() => _TeamDashboardPageState();
}

class _TeamDashboardPageState extends State<TeamDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamDashboardProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TeamDashboardProvider>().loadDashboard();
            },
          ),
        ],
      ),
      body: Consumer<TeamDashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.teamStats == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.teamStats == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(provider.error!, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => provider.loadDashboard(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadDashboard,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildPeriodSelector(provider),
                const SizedBox(height: 16),
                _buildStatsCards(provider),
                const SizedBox(height: 24),
                _buildResourceUsageSection(provider),
                const SizedBox(height: 24),
                _buildActivityChartSection(provider),
                const SizedBox(height: 24),
                _buildTopPerformersSection(provider),
                const SizedBox(height: 24),
                _buildMembersList(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector(TeamDashboardProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20),
            const SizedBox(width: 8),
            const Text('Período:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildPeriodChip(provider, 7, '7 dias'),
                    _buildPeriodChip(provider, 30, '30 dias'),
                    _buildPeriodChip(provider, 90, '90 dias'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodChip(TeamDashboardProvider provider, int days, String label) {
    final isSelected = provider.selectedDays == days;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            provider.changePeriod(days);
          }
        },
        selectedColor: RadianceColors.primary.withOpacity(0.2),
      ),
    );
  }

  Widget _buildStatsCards(TeamDashboardProvider provider) {
    final stats = provider.teamStats;
    if (stats == null) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Previsões',
            stats.totalPredictions.toString(),
            Icons.analytics,
            RadianceColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Este Mês',
            stats.predictionsThisMonth.toString(),
            Icons.trending_up,
            RadianceColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceUsageSection(TeamDashboardProvider provider) {
    final usage = provider.resourceUsage;
    if (usage == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Uso de Recursos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            _buildUsageBar(
              'Previsões',
              usage.predictionsUsed,
              usage.predictionsLimit,
              usage.predictionsPercentage,
              RadianceColors.primary,
            ),
            const SizedBox(height: 16),
            _buildUsageBar(
              'Membros',
              usage.membersUsed,
              usage.membersLimit,
              usage.membersPercentage,
              RadianceColors.info,
            ),
            const SizedBox(height: 16),
            _buildUsageBar(
              'Armazenamento',
              usage.storageUsedMB,
              usage.storageLimitMB,
              usage.storagePercentage,
              RadianceColors.warning,
              suffix: 'MB',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageBar(
    String label,
    int used,
    int limit,
    double percentage,
    Color color, {
    String suffix = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              '$used / $limit $suffix',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage > 90 ? RadianceColors.error : color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityChartSection(TeamDashboardProvider provider) {
    final activities = provider.memberActivities;
    if (activities.isEmpty) return const SizedBox.shrink();

    // Agregar atividades por dia
    final dailyTotals = <DateTime, int>{};
    for (final member in activities) {
      for (final daily in member.dailyActivities) {
        dailyTotals[daily.date] = (dailyTotals[daily.date] ?? 0) + daily.count;
      }
    }

    if (dailyTotals.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.show_chart, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'Nenhuma atividade no período',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final sortedDates = dailyTotals.keys.toList()..sort();
    final spots = sortedDates.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        dailyTotals[entry.value]!.toDouble(),
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atividade da Equipe',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300],
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (spots.length / 5).ceilToDouble(),
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= sortedDates.length) {
                            return const SizedBox.shrink();
                          }
                          final date = sortedDates[value.toInt()];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${date.day}/${date.month}',
                              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: RadianceColors.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: RadianceColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPerformersSection(TeamDashboardProvider provider) {
    final topPerformers = provider.topPerformers;
    if (topPerformers.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top 5 Membros',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...topPerformers.asMap().entries.map((entry) {
              final index = entry.key;
              final member = entry.value;
              return _buildPerformerTile(index + 1, member);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformerTile(int rank, MemberActivity member) {
    final medals = ['🥇', '🥈', '🥉'];
    final medal = rank <= 3 ? medals[rank - 1] : '$rankº';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? RadianceColors.primary.withOpacity(0.1)
                  : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                medal,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (member.lastActivity != null)
                  Text(
                    'Última atividade: ${_formatDate(member.lastActivity!)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: RadianceColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${member.predictionsCount}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: RadianceColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList(TeamDashboardProvider provider) {
    final members = provider.memberActivities;
    if (members.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Todos os Membros',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Chip(
                  label: Text('${members.length} membros'),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...members.map((member) => _buildMemberTile(member)),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(MemberActivity member) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: RadianceColors.primary.withOpacity(0.1),
        child: Text(
          member.userName[0].toUpperCase(),
          style: const TextStyle(color: RadianceColors.primary),
        ),
      ),
      title: Text(member.userName),
      subtitle: member.lastActivity != null
          ? Text('Último acesso: ${_formatDate(member.lastActivity!)}')
          : const Text('Sem atividade'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${member.predictionsCount}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'previsões',
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Agora';
      }
      return '${difference.inHours}h atrás';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}
