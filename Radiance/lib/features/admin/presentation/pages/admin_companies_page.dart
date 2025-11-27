import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_company_provider.dart';
import '../../domain/entities/admin_company_stats.dart';
import '../../../../core/theme/radiance_colors.dart';

class AdminCompaniesPage extends StatefulWidget {
  const AdminCompaniesPage({super.key});

  @override
  State<AdminCompaniesPage> createState() => _AdminCompaniesPageState();
}

class _AdminCompaniesPageState extends State<AdminCompaniesPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminCompanyProvider>().loadCompanies();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Empresas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AdminCompanyProvider>().loadCompanies();
            },
          ),
        ],
      ),
      body: Consumer<AdminCompanyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.companies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildSearchBar(provider),
              _buildStatsRow(provider),
              Expanded(child: _buildCompaniesList(provider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(AdminCompanyProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Pesquisar empresas...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    provider.clearFilters();
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) {
          if (value.length > 2 || value.isEmpty) {
            provider.searchCompanies(value);
          }
        },
      ),
    );
  }

  Widget _buildStatsRow(AdminCompanyProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              provider.totalCompanies.toString(),
              Icons.business,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Ativas',
              provider.activeCompanies.toString(),
              Icons.check_circle,
              Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Atenção',
              provider.companiesNeedingAttention.toString(),
              Icons.warning,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildCompaniesList(AdminCompanyProvider provider) {
    if (provider.companies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Nenhuma empresa encontrada', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadCompanies,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.companies.length,
        itemBuilder: (context, index) {
          return _buildCompanyCard(provider.companies[index], provider);
        },
      ),
    );
  }

  Widget _buildCompanyCard(AdminCompanyStats stats, AdminCompanyProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: stats.statusColor.withOpacity(0.2),
          child: Icon(Icons.business, color: stats.statusColor),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                stats.company.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Chip(
              label: Text(
                stats.tierDisplay,
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
              backgroundColor: _getTierColor(stats.subscription?.tier),
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${stats.totalMembers} membros', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 16),
                Icon(Icons.analytics, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${stats.totalPredictions} previsões', style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: stats.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                stats.statusDisplay,
                style: TextStyle(fontSize: 10, color: stats.statusColor),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleAction(value, stats, provider),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'details', child: Text('Ver Detalhes')),
            if (stats.company.isActive)
              const PopupMenuItem(value: 'suspend', child: Text('Suspender'))
            else
              const PopupMenuItem(value: 'activate', child: Text('Ativar')),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        onTap: () => _showCompanyDetails(stats),
      ),
    );
  }

  Color _getTierColor(SubscriptionTier? tier) {
    if (tier == null) return Colors.grey;
    switch (tier) {
      case SubscriptionTier.free:
        return RadianceColors.subscriptionFree;
      case SubscriptionTier.pro:
        return RadianceColors.subscriptionPro;
      case SubscriptionTier.enterprise:
        return RadianceColors.subscriptionEnterprise;
    }
  }

  void _showFilters() {
    // TODO: Implement filter dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filtros em desenvolvimento')),
    );
  }

  void _showCompanyDetails(AdminCompanyStats stats) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stats.company.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                _buildDetailRow('ID', stats.company.id),
                _buildDetailRow('Status', stats.statusDisplay),
                _buildDetailRow('Plano', stats.tierDisplay),
                _buildDetailRow('Membros', '${stats.totalMembers} (${stats.activeMembers} ativos)'),
                _buildDetailRow('Previsões Totais', stats.totalPredictions.toString()),
                _buildDetailRow('Este Mês', stats.predictionsThisMonth.toString()),
                _buildDetailRow('Receita', 'R\$ ${stats.totalRevenue.toStringAsFixed(2)}'),
                _buildDetailRow('Criado em', _formatDate(stats.createdAt)),
                if (stats.lastActivity != null)
                  _buildDetailRow('Última Atividade', _formatDate(stats.lastActivity!)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _handleAction(
    String action,
    AdminCompanyStats stats,
    AdminCompanyProvider provider,
  ) async {
    switch (action) {
      case 'details':
        _showCompanyDetails(stats);
        break;
      case 'suspend':
        final confirm = await _confirmDialog('Suspender Empresa', 'Deseja suspender ${stats.company.name}?');
        if (confirm == true) {
          final success = await provider.suspendCompany(stats.company.id);
          _showResult(success, 'Empresa suspensa', 'Erro ao suspender');
        }
        break;
      case 'activate':
        final success = await provider.activateCompany(stats.company.id);
        _showResult(success, 'Empresa ativada', 'Erro ao ativar');
        break;
      case 'delete':
        final confirm = await _confirmDialog('Excluir Empresa', 'Tem certeza? Esta ação não pode ser desfeita.');
        if (confirm == true) {
          final success = await provider.deleteCompany(stats.company.id);
          _showResult(success, 'Empresa excluída', 'Erro ao excluir');
        }
        break;
    }
  }

  Future<bool?> _confirmDialog(String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirmar')),
        ],
      ),
    );
  }

  void _showResult(bool success, String successMsg, String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? successMsg : errorMsg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
