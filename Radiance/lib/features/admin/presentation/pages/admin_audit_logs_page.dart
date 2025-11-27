import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../providers/admin_audit_provider.dart';
import '../../domain/entities/admin_audit_log.dart';

class AdminAuditLogsPage extends StatefulWidget {
  const AdminAuditLogsPage({super.key});

  @override
  State<AdminAuditLogsPage> createState() => _AdminAuditLogsPageState();
}

class _AdminAuditLogsPageState extends State<AdminAuditLogsPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AdminAuditProvider>();
      provider.loadLogs(reset: true);
      provider.loadStats();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<AdminAuditProvider>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs de Auditoria'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportLogs,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AdminAuditProvider>().refresh(),
          ),
        ],
      ),
      body: Consumer<AdminAuditProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Search bar
              _buildSearchBar(provider),
              
              // Active filters
              if (provider.filters.hasActiveFilters)
                _buildActiveFilters(provider),
              
              // Stats bar
              if (provider.stats != null)
                _buildStatsBar(provider),
              
              // Logs list
              Expanded(
                child: _buildLogsList(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(AdminAuditProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por ação, usuário ou alvo...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    provider.searchLogs('');
                  },
                )
              : null,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (value) => provider.searchLogs(value),
      ),
    );
  }

  Widget _buildActiveFilters(AdminAuditProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: [
          if (provider.filters.category != null)
            Chip(
              label: Text('Categoria: ${provider.filters.category!.name}'),
              onDeleted: () => provider.clearFilter('category'),
              deleteIcon: const Icon(Icons.close, size: 18),
            ),
          if (provider.filters.severity != null)
            Chip(
              label: Text('Severidade: ${provider.filters.severity!.name}'),
              onDeleted: () => provider.clearFilter('severity'),
              deleteIcon: const Icon(Icons.close, size: 18),
            ),
          if (provider.filters.startDate != null || provider.filters.endDate != null)
            Chip(
              label: Text(
                'Data: ${_formatDateRange(provider.filters.startDate, provider.filters.endDate)}',
              ),
              onDeleted: () => provider.clearFilter('dateRange'),
              deleteIcon: const Icon(Icons.close, size: 18),
            ),
          if (provider.filters.activeFilterCount > 0)
            TextButton.icon(
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Limpar Filtros'),
              onPressed: () => provider.clearFilters(),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(AdminAuditProvider provider) {
    final stats = provider.stats!;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatChip(
            'Total',
            stats.totalLogs.toString(),
            Colors.blue,
            Icons.list,
          ),
          _buildStatChip(
            'Info',
            stats.infoCount.toString(),
            Colors.grey,
            Icons.info_outline,
          ),
          _buildStatChip(
            'Avisos',
            stats.warningCount.toString(),
            Colors.orange,
            Icons.warning_amber,
          ),
          _buildStatChip(
            'Críticos',
            stats.criticalCount.toString(),
            Colors.red,
            Icons.error_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildLogsList(AdminAuditProvider provider) {
    if (provider.isLoading && provider.logs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.logs.isEmpty) {
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

    if (provider.logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nenhum log encontrado',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tente ajustar os filtros',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: provider.logs.length + (provider.hasMoreLogs ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == provider.logs.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final log = provider.logs[index];
          return _buildLogCard(log);
        },
      ),
    );
  }

  Widget _buildLogCard(AdminAuditLog log) {
    final severityColor = _getSeverityColor(log.severity);
    final categoryIcon = _getCategoryIcon(log.category);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InkWell(
        onTap: () => _showLogDetails(log),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(categoryIcon, size: 20, color: severityColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      log.action,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildSeverityBadge(log.severity),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    log.userName ?? 'Sistema',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(log.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (log.targetName != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.target, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Alvo: ${log.targetName} (${log.targetType ?? "N/A"})',
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (log.metadata != null && log.metadata!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  log.formattedMetadata,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(AuditLogSeverity severity) {
    Color color;
    String label;
    
    switch (severity) {
      case AuditLogSeverity.info:
        color = Colors.blue;
        label = 'INFO';
        break;
      case AuditLogSeverity.warning:
        color = Colors.orange;
        label = 'AVISO';
        break;
      case AuditLogSeverity.critical:
        color = Colors.red;
        label = 'CRÍTICO';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showLogDetails(AdminAuditLog log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detalhes do Log',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              _buildDetailRow('ID', log.id),
              _buildDetailRow('Ação', log.action),
              _buildDetailRow('Categoria', log.category.name),
              _buildDetailRow('Severidade', log.severity.name),
              _buildDetailRow('Usuário', log.userName ?? 'Sistema'),
              if (log.userId != null)
                _buildDetailRow('ID do Usuário', log.userId!),
              if (log.targetName != null)
                _buildDetailRow('Alvo', log.targetName!),
              if (log.targetType != null)
                _buildDetailRow('Tipo do Alvo', log.targetType!),
              if (log.targetId != null)
                _buildDetailRow('ID do Alvo', log.targetId!),
              if (log.ipAddress != null)
                _buildDetailRow('Endereço IP', log.ipAddress!),
              if (log.userAgent != null)
                _buildDetailRow('User Agent', log.userAgent!),
              _buildDetailRow('Data/Hora', _formatDateTime(log.createdAt)),
              if (log.metadata != null && log.metadata!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Metadados',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: log.metadata!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(entry.value.toString()),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
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

  void _showFilterDialog() {
    final provider = context.read<AdminAuditProvider>();
    final currentFilters = provider.filters;

    AuditLogCategory? selectedCategory = currentFilters.category;
    AuditLogSeverity? selectedSeverity = currentFilters.severity;
    DateTime? startDate = currentFilters.startDate;
    DateTime? endDate = currentFilters.endDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filtros'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Categoria', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Todas'),
                      selected: selectedCategory == null,
                      onSelected: (selected) {
                        setState(() => selectedCategory = null);
                      },
                    ),
                    ...AuditLogCategory.values.map((category) {
                      return FilterChip(
                        label: Text(category.name),
                        selected: selectedCategory == category,
                        onSelected: (selected) {
                          setState(() => selectedCategory = selected ? category : null);
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Severidade', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Todas'),
                      selected: selectedSeverity == null,
                      onSelected: (selected) {
                        setState(() => selectedSeverity = null);
                      },
                    ),
                    ...AuditLogSeverity.values.map((severity) {
                      return FilterChip(
                        label: Text(severity.name),
                        selected: selectedSeverity == severity,
                        onSelected: (selected) {
                          setState(() => selectedSeverity = selected ? severity : null);
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Período', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(startDate != null 
                          ? DateFormat('dd/MM/yy').format(startDate!)
                          : 'Data Inicial'),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() => startDate = date);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(endDate != null 
                          ? DateFormat('dd/MM/yy').format(endDate!)
                          : 'Data Final'),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: endDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() => endDate = date);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                if (startDate != null || endDate != null)
                  TextButton.icon(
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Limpar Datas'),
                    onPressed: () {
                      setState(() {
                        startDate = null;
                        endDate = null;
                      });
                    },
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newFilters = AuditLogFilters(
                  searchQuery: currentFilters.searchQuery,
                  category: selectedCategory,
                  severity: selectedSeverity,
                  startDate: startDate,
                  endDate: endDate,
                  sortBy: currentFilters.sortBy,
                  ascending: currentFilters.ascending,
                );
                provider.applyFilters(newFilters);
                Navigator.pop(context);
              },
              child: const Text('Aplicar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportLogs() async {
    final provider = context.read<AdminAuditProvider>();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Exportando logs...'),
          ],
        ),
      ),
    );

    try {
      final csv = await provider.exportToCSV();
      
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (csv != null) {
        // Save file
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'audit_logs_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(csv);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logs exportados: $fileName'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao exportar logs'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color _getSeverityColor(AuditLogSeverity severity) {
    switch (severity) {
      case AuditLogSeverity.info:
        return Colors.blue;
      case AuditLogSeverity.warning:
        return Colors.orange;
      case AuditLogSeverity.critical:
        return Colors.red;
    }
  }

  IconData _getCategoryIcon(AuditLogCategory category) {
    switch (category) {
      case AuditLogCategory.user:
        return Icons.person;
      case AuditLogCategory.company:
        return Icons.business;
      case AuditLogCategory.subscription:
        return Icons.subscriptions;
      case AuditLogCategory.payment:
        return Icons.payment;
      case AuditLogCategory.auth:
        return Icons.lock;
      case AuditLogCategory.system:
        return Icons.settings;
      case AuditLogCategory.security:
        return Icons.security;
    }
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yy HH:mm:ss').format(date);
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start != null && end != null) {
      return '${DateFormat('dd/MM/yy').format(start)} - ${DateFormat('dd/MM/yy').format(end)}';
    } else if (start != null) {
      return 'Desde ${DateFormat('dd/MM/yy').format(start)}';
    } else if (end != null) {
      return 'Até ${DateFormat('dd/MM/yy').format(end)}';
    }
    return '';
  }
}
