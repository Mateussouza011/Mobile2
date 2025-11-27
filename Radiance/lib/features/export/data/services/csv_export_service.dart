import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/export_config.dart';
import '../../../../core/data/models/prediction_model.dart';

/// Serviço de exportação para CSV
class CsvExportService {
  /// Exporta previsões para CSV
  Future<ExportResult> exportPredictions({
    required List<PredictionModel> predictions,
    required ExportConfig config,
  }) async {
    final rows = <List<dynamic>>[
      // Header
      [
        'ID',
        'Data',
        'Hora',
        'Quilates',
        'Corte',
        'Cor',
        'Clareza',
        'Profundidade',
        'Tabela',
        'Preço Previsto (R\$)',
        'Empresa ID',
        'Usuário ID',
      ],
      // Data
      ...predictions.map((p) => [
            p.id,
            _formatDate(p.timestamp),
            _formatTime(p.timestamp),
            p.carat.toStringAsFixed(2),
            p.cut ?? '',
            p.color ?? '',
            p.clarity ?? '',
            p.depth?.toStringAsFixed(2) ?? '',
            p.table?.toStringAsFixed(2) ?? '',
            p.predictedPrice.toStringAsFixed(2),
            p.companyId ?? '',
            p.userId,
          ]),
    ];

    // Converter para CSV
    const converter = ListToCsvConverter();
    final csv = converter.convert(rows);

    // Salvar arquivo
    final output = await _getOutputDirectory();
    final fileName = 'predictions_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File('${output.path}/$fileName');
    await file.writeAsString(csv);

    return ExportResult(
      filePath: file.path,
      fileName: fileName,
      fileSize: await file.length(),
      format: ExportFormat.csv,
      generatedAt: DateTime.now(),
    );
  }

  /// Exporta métricas de uso para CSV
  Future<ExportResult> exportUsageMetrics({
    required Map<String, dynamic> metrics,
    required ExportConfig config,
  }) async {
    final rows = <List<dynamic>>[
      ['Métrica', 'Valor', 'Período'],
      ...metrics.entries.map((e) => [
            e.key,
            e.value.toString(),
            '${_formatDate(config.startDate)} - ${_formatDate(config.endDate)}',
          ]),
    ];

    const converter = ListToCsvConverter();
    final csv = converter.convert(rows);

    final output = await _getOutputDirectory();
    final fileName = 'usage_metrics_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File('${output.path}/$fileName');
    await file.writeAsString(csv);

    return ExportResult(
      filePath: file.path,
      fileName: fileName,
      fileSize: await file.length(),
      format: ExportFormat.csv,
      generatedAt: DateTime.now(),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  Future<Directory> _getOutputDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/exports');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    return exportDir;
  }
}
