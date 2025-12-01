import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/export_config.dart';
import '../../data/services/pdf_export_service.dart';
import '../../data/services/csv_export_service.dart';
import '../../../../core/data/repositories/prediction_history_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../multi_tenant/presentation/providers/tenant_provider.dart';

/// Provider para gerenciar exportações
class ExportProvider extends ChangeNotifier {
  final PdfExportService _pdfService;
  final CsvExportService _csvService;
  final PredictionHistoryRepository _predictionRepository;
  final TenantProvider _tenantProvider;

  bool _isExporting = false;
  String? _error;
  ExportResult? _lastExport;

  ExportProvider({
    required PdfExportService pdfService,
    required CsvExportService csvService,
    required PredictionHistoryRepository predictionRepository,
    required TenantProvider tenantProvider,
  })  : _pdfService = pdfService,
        _csvService = csvService,
        _predictionRepository = predictionRepository,
        _tenantProvider = tenantProvider;

  // Getters
  bool get isExporting => _isExporting;
  String? get error => _error;
  ExportResult? get lastExport => _lastExport;

  /// Exporta relatório de previsões
  Future<Either<Failure, ExportResult>> exportPredictions(
    ExportConfig config,
  ) async {
    _setExporting(true);
    _error = null;

    try {
      final companyId = config.companyId ?? _tenantProvider.currentCompany?.id;
      
      if (companyId == null) {
        _setExporting(false);
        return const Left(ValidationFailure('Nenhuma empresa selecionada'));
      }

      // Buscar previsões do período
      final allPredictions = await _predictionRepository.getPredictionsForUser(
        0, // TODO: Get user ID from auth
        companyId: companyId,
      );
      
      // Filtrar por período
      final predictions = allPredictions.where((p) {
        return p.createdAt.isAfter(config.startDate) &&
               p.createdAt.isBefore(config.endDate.add(const Duration(days: 1)));
      }).toList();

      if (predictions.isEmpty) {
        _setExporting(false);
        _error = 'Nenhuma previsão encontrada no período selecionado';
        return const Left(NotFoundFailure('Nenhuma previsão encontrada'));
      }

      // Exportar de acordo com o formato
      ExportResult result;
      
      switch (config.format) {
        case ExportFormat.pdf:
          result = await _pdfService.generatePredictionsReport(
            predictions: predictions,
            config: config,
            companyName: _tenantProvider.currentCompany?.name,
          );
          break;
        case ExportFormat.csv:
          result = await _csvService.exportPredictions(
            predictions: predictions,
            config: config,
          );
          break;
        case ExportFormat.excel:
          // TODO: Implementar exportação Excel
          _setExporting(false);
          return const Left(ValidationFailure('Formato Excel ainda não suportado'));
      }

      _lastExport = result;
      _setExporting(false);
      
      return Right(result);
    } catch (e) {
      _error = 'Erro ao exportar: $e';
      _setExporting(false);
      return Left(ServerFailure('Erro ao exportar: $e'));
    }
  }

  /// Exporta métricas de uso
  Future<Either<Failure, ExportResult>> exportUsageMetrics(
    ExportConfig config,
  ) async {
    _setExporting(true);
    _error = null;

    try {
      final companyId = config.companyId ?? _tenantProvider.currentCompany?.id;
      
      if (companyId == null) {
        _setExporting(false);
        return const Left(ValidationFailure('Nenhuma empresa selecionada'));
      }

      // Calcular métricas
      final allPredictions = await _predictionRepository.getPredictionsForUser(
        0, // TODO: Get user ID from auth
        companyId: companyId,
      );

      final filteredPredictions = allPredictions.where((p) {
        return p.createdAt.isAfter(config.startDate) &&
               p.createdAt.isBefore(config.endDate.add(const Duration(days: 1)));
      }).toList();

      final metrics = {
        'Total de Previsões': filteredPredictions.length,
        'Período': '${_formatDate(config.startDate)} - ${_formatDate(config.endDate)}',
        'Empresa': _tenantProvider.currentCompany?.name ?? 'N/A',
      };

      final result = await _csvService.exportUsageMetrics(
        metrics: metrics,
        config: config,
      );

      _lastExport = result;
      _setExporting(false);
      
      return Right(result);
    } catch (e) {
      _error = 'Erro ao exportar métricas: $e';
      _setExporting(false);
      return Left(ServerFailure('Erro ao exportar: $e'));
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setExporting(bool value) {
    _isExporting = value;
    notifyListeners();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
