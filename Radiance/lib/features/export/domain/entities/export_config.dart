import 'package:equatable/equatable.dart';

/// Formato de exportação
enum ExportFormat {
  pdf,
  csv,
  excel,
}

/// Tipo de relatório para exportação
enum ReportType {
  predictions,        // Relatório de previsões
  teamActivity,       // Atividade da equipe
  usage,             // Uso de recursos
  financial,         // Financeiro (pagamentos)
}

/// Configuração de exportação
class ExportConfig extends Equatable {
  final ExportFormat format;
  final ReportType reportType;
  final DateTime startDate;
  final DateTime endDate;
  final String? companyId;
  final String? userId;
  final Map<String, dynamic>? filters;
  final bool includeCharts;
  final bool includeDetails;

  const ExportConfig({
    required this.format,
    required this.reportType,
    required this.startDate,
    required this.endDate,
    this.companyId,
    this.userId,
    this.filters,
    this.includeCharts = true,
    this.includeDetails = true,
  });

  ExportConfig copyWith({
    ExportFormat? format,
    ReportType? reportType,
    DateTime? startDate,
    DateTime? endDate,
    String? companyId,
    String? userId,
    Map<String, dynamic>? filters,
    bool? includeCharts,
    bool? includeDetails,
  }) {
    return ExportConfig(
      format: format ?? this.format,
      reportType: reportType ?? this.reportType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      companyId: companyId ?? this.companyId,
      userId: userId ?? this.userId,
      filters: filters ?? this.filters,
      includeCharts: includeCharts ?? this.includeCharts,
      includeDetails: includeDetails ?? this.includeDetails,
    );
  }

  @override
  List<Object?> get props => [
        format,
        reportType,
        startDate,
        endDate,
        companyId,
        userId,
        filters,
        includeCharts,
        includeDetails,
      ];
}

/// Resultado de exportação
class ExportResult extends Equatable {
  final String filePath;
  final String fileName;
  final int fileSize;
  final ExportFormat format;
  final DateTime generatedAt;

  const ExportResult({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.format,
    required this.generatedAt,
  });

  String get fileSizeFormatted {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  List<Object?> get props => [filePath, fileName, fileSize, format, generatedAt];
}
