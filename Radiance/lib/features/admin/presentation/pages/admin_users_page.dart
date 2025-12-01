import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/radiance_colors.dart';
import '../providers/admin_user_provider.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/admin_user_stats.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminUserProvider>().loadUsers();
      context.read<AdminUserProvider>().loadSystemStats();
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
        title: const Text('Gerenciar Usuários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AdminUserProvider>().loadUsers();
              context.read<AdminUserProvider>().loadSystemStats();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatsRow(),
          Expanded(child: _buildUsersList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por nome ou email...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<AdminUserProvider>().searchUsers('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.length >= 3 || value.isEmpty) {
            context.read<AdminUserProvider>().searchUsers(value);
          }
        },
      ),
    );
  }

  Widget _buildStatsRow() {
    return Consumer<AdminUserProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  provider.totalUsers.toString(),
                  Icons.people,
                  RadianceColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Ativos',
                  provider.activeUsers.toString(),
                  Icons.check_circle,
                  RadianceColors.success,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Desativados',
                  provider.disabledUsers.toString(),
                  Icons.block,
                  RadianceColors.error,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Atenção',
                  provider.usersNeedingAttention.toString(),
                  Icons.warning,
                  RadianceColors.warning,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: RadianceColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return Consumer<AdminUserProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: RadianceColors.error),
                const SizedBox(height: 16),
                Text(provider.error!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadUsers(),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        if (provider.users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: RadianceColors.iconMuted),
                const SizedBox(height: 16),
                Text(
                  'Nenhum usuário encontrado',
                  style: TextStyle(color: RadianceColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadUsers(),
          child: ListView.builder(
            itemCount: provider.users.length,
            itemBuilder: (context, index) {
              final userStats = provider.users[index];
              return _buildUserCard(userStats);
            },
          ),
        );
      },
    );
  }

  Widget _buildUserCard(AdminUserStats userStats) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _showUserDetails(userStats),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: userStats.statusColor,
                    child: Text(
                      userStats.user.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userStats.user.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userStats.user.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: RadianceColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleAction(value, userStats),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'details',
                        child: Row(
                          children: [
                            Icon(Icons.info_outline),
                            SizedBox(width: 8),
                            Text('Ver detalhes'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: userStats.isActive ? 'disable' : 'enable',
                        child: Row(
                          children: [
                            Icon(userStats.isActive ? Icons.block : Icons.check_circle),
                            const SizedBox(width: 8),
                            Text(userStats.isActive ? 'Desativar' : 'Reativar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'reset_password',
                        child: Row(
                          children: [
                            Icon(Icons.lock_reset),
                            SizedBox(width: 8),
                            Text('Resetar senha'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'activity',
                        child: Row(
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: 8),
                            Text('Ver atividade'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(
                    Icons.business,
                    userStats.companiesDisplay,
                    RadianceColors.primary,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    Icons.work,
                    userStats.rolesDisplay,
                    RadianceColors.secondary,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    Icons.analytics,
                    '${userStats.totalPredictions} previsões',
                    RadianceColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: userStats.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      userStats.statusDisplay,
                      style: TextStyle(
                        color: userStats.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (userStats.lastLogin != null)
                    Text(
                      'Último login: ${_formatDate(userStats.lastLogin!)}',
                      style: TextStyle(fontSize: 12, color: RadianceColors.textSecondary),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }

  void _handleAction(String action, AdminUserStats userStats) {
    switch (action) {
      case 'details':
        _showUserDetails(userStats);
        break;
      case 'disable':
        _confirmDisable(userStats);
        break;
      case 'enable':
        _confirmEnable(userStats);
        break;
      case 'reset_password':
        _confirmResetPassword(userStats);
        break;
      case 'activity':
        _showActivityLogs(userStats);
        break;
    }
  }

  void _showUserDetails(AdminUserStats userStats) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              controller: scrollController,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Detalhes do Usuário',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                _buildDetailRow('ID', userStats.user.id),
                _buildDetailRow('Nome', userStats.user.name),
                _buildDetailRow('Email', userStats.user.email),
                if (userStats.user.phone != null)
                  _buildDetailRow('Telefone', userStats.user.phone!),
                _buildDetailRow('Status', userStats.statusDisplay),
                _buildDetailRow('Empresas', userStats.companiesDisplay),
                _buildDetailRow('Funções', userStats.rolesDisplay),
                _buildDetailRow('Total de Previsões', userStats.totalPredictions.toString()),
                _buildDetailRow('Previsões este mês', userStats.predictionsThisMonth.toString()),
                if (userStats.lastActivity != null)
                  _buildDetailRow('Última atividade', _formatDate(userStats.lastActivity!)),
                if (userStats.lastLogin != null)
                  _buildDetailRow('Último login', _formatDate(userStats.lastLogin!)),
                _buildDetailRow('Criado em', _formatDate(userStats.createdAt)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _confirmDisable(AdminUserStats userStats) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desativar Usuário'),
        content: Text(
          'Tem certeza que deseja desativar o usuário ${userStats.user.name}? '
          'Ele não poderá mais fazer login até ser reativado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context
                  .read<AdminUserProvider>()
                  .disableUser(userStats.user.id);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Usuário desativado com sucesso'
                          : 'Erro ao desativar usuário',
                    ),
                    backgroundColor: success ? RadianceColors.success : RadianceColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: RadianceColors.error),
            child: const Text('Desativar'),
          ),
        ],
      ),
    );
  }

  void _confirmEnable(AdminUserStats userStats) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reativar Usuário'),
        content: Text(
          'Deseja reativar o usuário ${userStats.user.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context
                  .read<AdminUserProvider>()
                  .enableUser(userStats.user.id);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Usuário reativado com sucesso'
                          : 'Erro ao reativar usuário',
                    ),
                    backgroundColor: success ? RadianceColors.success : RadianceColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: RadianceColors.success),
            child: const Text('Reativar'),
          ),
        ],
      ),
    );
  }

  void _confirmResetPassword(AdminUserStats userStats) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resetar Senha'),
        content: Text(
          'Deseja resetar a senha do usuário ${userStats.user.name}? '
          'Uma senha temporária será gerada e exibida.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final tempPassword = await context
                  .read<AdminUserProvider>()
                  .resetPassword(userStats.user.id);

              if (mounted) {
                if (tempPassword != null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Senha Temporária'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Senha temporária gerada com sucesso. '
                            'O usuário deverá alterar ao fazer login.',
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: RadianceColors.cardBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tempPassword,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: tempPassword));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Senha copiada!'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Erro ao resetar senha'),
                      backgroundColor: RadianceColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Resetar'),
          ),
        ],
      ),
    );
  }

  void _showActivityLogs(AdminUserStats userStats) async {
    await context.read<AdminUserProvider>().loadActivityLogs(userStats.user.id);
    
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Consumer<AdminUserProvider>(
              builder: (context, provider, _) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Logs de Atividade',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: provider.activityLogs.isEmpty
                          ? const Center(child: Text('Nenhuma atividade registrada'))
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: provider.activityLogs.length,
                              itemBuilder: (context, index) {
                                final log = provider.activityLogs[index];
                                return ListTile(
                                  leading: Icon(log.actionIcon),
                                  title: Text(log.actionDisplay),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (log.details != null) Text(log.details!),
                                      Text(
                                        _formatDateTime(log.timestamp),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtros'),
        content: const Text('Filtros em desenvolvimento'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
