import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/export_config.dart';
import '../providers/export_provider.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';
import '../../../multi_tenant/presentation/providers/tenant_provider.dart';
import '../../../../core/theme/radiance_colors.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  ExportFormat _selectedFormat = ExportFormat.pdf;
  ReportType _selectedReportType = ReportType.predictions;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _includeCharts = true;
  bool _includeDetails = true;

  @override
  Widget build(BuildContext context) {
    final tenantProvider = context.watch<TenantProvider>();
    final hasExportFeature = tenantProvider.currentSubscription?.limits.hasExportFeatures ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportar Relatórios'),
      ),
      body: !hasExportFeature
          ? _buildUpgradePrompt()
          : Consumer<ExportProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFormatSelector(),
                      const SizedBox(height: 24),
                      _buildReportTypeSelector(),
                      const SizedBox(height: 24),
                      _buildDateRangeSelector(context),
                      const SizedBox(height: 24),
                      _buildOptionsCard(),
                      const SizedBox(height: 32),
                      if (provider.lastExport != null) ...[
                        _buildLastExportCard(provider),
                        const SizedBox(height: 16),
                      ],
                      if (provider.error != null) ...[
                        _buildErrorCard(provider),
                        const SizedBox(height: 16),
                      ],
                      ElevatedButton.icon(
                        onPressed: provider.isExporting ? null : _handleExport,
                        icon: provider.isExporting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.download),
                        label: Text(
                          provider.isExporting ? 'Gerando...' : 'Gerar Relatório',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: RadianceColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildUpgradePrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.workspace_premium,
              size: 80,
              color: RadianceColors.warning,
            ),
            const SizedBox(height: 24),
            Text(
              'Recurso Premium',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'A exportação de relatórios está disponível apenas nos planos Pro e Enterprise.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navegar para página de planos
              },
              icon: const Icon(Icons.upgrade),
              label: const Text('Fazer Upgrade'),
              style: ElevatedButton.styleFrom(
                backgroundColor: RadianceColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formato',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildFormatOption(
                    format: ExportFormat.pdf,
                    icon: Icons.picture_as_pdf,
                    label: 'PDF',
                    description: 'Relatório completo com gráficos',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFormatOption(
                    format: ExportFormat.csv,
                    icon: Icons.table_chart,
                    label: 'CSV',
                    description: 'Dados tabulares',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFormatOption(
                    format: ExportFormat.excel,
                    icon: Icons.grid_on,
                    label: 'Excel',
                    description: 'Em breve',
                    isDisabled: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatOption({
    required ExportFormat format,
    required IconData icon,
    required String label,
    required String description,
    bool isDisabled = false,
  }) {
    final isSelected = _selectedFormat == format && !isDisabled;

    return InkWell(
      onTap: isDisabled ? null : () => setState(() => _selectedFormat = format),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? RadianceColors.primary.withOpacity(0.1)
              : Colors.grey[100],
          border: Border.all(
            color: isSelected ? RadianceColors.primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isDisabled
                  ? Colors.grey
                  : (isSelected ? RadianceColors.primary : Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDisabled ? Colors.grey : null,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo de Relatório',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ReportType>(
              value: _selectedReportType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: [
                DropdownMenuItem(
                  value: ReportType.predictions,
                  child: Row(
                    children: [
                      Icon(Icons.analytics, size: 20, color: RadianceColors.primary),
                      const SizedBox(width: 12),
                      const Text('Relatório de Previsões'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: ReportType.teamActivity,
                  child: Row(
                    children: [
                      Icon(Icons.people, size: 20, color: RadianceColors.info),
                      const SizedBox(width: 12),
                      const Text('Atividade da Equipe'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: ReportType.usage,
                  child: Row(
                    children: [
                      Icon(Icons.bar_chart, size: 20, color: RadianceColors.success),
                      const SizedBox(width: 12),
                      const Text('Uso de Recursos'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedReportType = value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Período',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'Data Inicial',
                    date: _startDate,
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    label: 'Data Final',
                    date: _endDate,
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(_formatDate(date)),
      ),
    );
  }

  Widget _buildOptionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Opções',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (_selectedFormat == ExportFormat.pdf) ...[
              CheckboxListTile(
                title: const Text('Incluir gráficos'),
                subtitle: const Text('Adiciona visualizações de dados'),
                value: _includeCharts,
                onChanged: (value) {
                  setState(() => _includeCharts = value ?? true);
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              CheckboxListTile(
                title: const Text('Incluir detalhes'),
                subtitle: const Text('Lista completa de registros'),
                value: _includeDetails,
                onChanged: (value) {
                  setState(() => _includeDetails = value ?? true);
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLastExportCard(ExportProvider provider) {
    final export = provider.lastExport!;
    
    return Card(
      color: RadianceColors.success.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: RadianceColors.success),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Exportação Concluída',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${export.fileName} (${export.fileSizeFormatted})',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareFile(export.filePath),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(ExportProvider provider) {
    return Card(
      color: RadianceColors.error.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: RadianceColors.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                provider.error!,
                style: TextStyle(color: RadianceColors.error),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => provider.clearError(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  Future<void> _handleExport() async {
    final provider = context.read<ExportProvider>();
    
    final config = ExportConfig(
      format: _selectedFormat,
      reportType: _selectedReportType,
      startDate: _startDate,
      endDate: _endDate,
      includeCharts: _includeCharts,
      includeDetails: _includeDetails,
    );

    final result = await provider.exportPredictions(config);

    if (!mounted) return;

    result.fold(
      (failure) {
        // Erro já está sendo exibido pelo provider
      },
      (exportResult) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Relatório gerado com sucesso!'),
            backgroundColor: RadianceColors.success,
            action: SnackBarAction(
              label: 'Compartilhar',
              textColor: Colors.white,
              onPressed: () => _shareFile(exportResult.filePath),
            ),
          ),
        );
      },
    );
  }

  Future<void> _shareFile(String filePath) async {
    await Share.shareXFiles([XFile(filePath)]);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
