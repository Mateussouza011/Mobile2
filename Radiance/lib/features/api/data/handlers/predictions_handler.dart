import 'package:dartz/dartz.dart';
import '../../domain/entities/api_response.dart';
import '../../../api_keys/domain/entities/api_key.dart';
import '../../../../core/data/repositories/prediction_history_repository.dart';
import '../../../../core/data/models/prediction_model.dart';
import '../../../../core/error/failures.dart';

/// Handler para endpoints de previsões
/// Nota: Esta é uma implementação de referência para documentação da API.
/// Em produção, os endpoints seriam implementados em um servidor backend real.
class PredictionsHandler {
  final PredictionHistoryRepository _historyRepository;

  PredictionsHandler({
    required PredictionHistoryRepository historyRepository,
  }) : _historyRepository = historyRepository;

  /// GET /api/v1/predictions
  /// Lista previsões da empresa
  Future<Either<Failure, ApiResponse<List<Map<String, dynamic>>>>> getPredictions({
    required ApiKey apiKey,
    int page = 1,
    int perPage = 20,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Verificar permissão
      if (!apiKey.permissions.contains('read:predictions')) {
        return const Left(UnauthorizedFailure('Missing permission: read:predictions'));
      }

      // Validar paginação
      if (page < 1) page = 1;
      if (perPage < 1 || perPage > 100) perPage = 20;

      // Buscar previsões da empresa (usando userId 0 para API)
      final predictions = await _historyRepository.getPredictionsForUser(
        0,
        companyId: apiKey.companyId,
      );

      // Filtrar por data se necessário
      var filtered = predictions;
          if (startDate != null) {
            filtered = filtered.where((p) => p.createdAt.isAfter(startDate)).toList();
          }
          if (endDate != null) {
            filtered = filtered.where((p) => p.createdAt.isBefore(endDate)).toList();
          }

          // Ordenar por data (mais recentes primeiro)
          filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          // Calcular paginação
          final total = filtered.length;
          final totalPages = (total / perPage).ceil();
          final skip = (page - 1) * perPage;
          final paginated = filtered.skip(skip).take(perPage).toList();

          // Converter para JSON
          final data = paginated.map((p) => _predictionToJson(p)).toList();

          return Right(
            ApiResponse.success(
              data: data,
              meta: {
                'pagination': PaginationMeta(
                  page: page,
                  perPage: perPage,
                  total: total,
                  totalPages: totalPages,
                ).toJson(),
              },
          ),
        );
    } catch (e) {
      return Left(ServerFailure('Error fetching predictions: $e'));
    }
  }  /// POST /api/v1/predictions
  /// Cria uma nova previsão
  Future<Either<Failure, ApiResponse<Map<String, dynamic>>>> createPrediction({
    required ApiKey apiKey,
    required Map<String, dynamic> body,
  }) async {
    try {
      // Verificar permissão
      if (!apiKey.permissions.contains('write:predictions')) {
        return const Left(UnauthorizedFailure('Missing permission: write:predictions'));
      }

      // Validar campos obrigatórios
      final validationError = _validatePredictionBody(body);
      if (validationError != null) {
        return Left(ValidationFailure(validationError));
      }

      // Calcular previsão mockada (fórmula simplificada para demonstração)
      // Em produção, usaria modelo ML real no backend
      final carat = (body['carat'] as num).toDouble();
      final mockPrice = _calculateMockPrice(carat, body['cut'] as String, body['color'] as String);

      // Salvar no histórico
      final historyModel = PredictionHistoryModel(
        id: null, // Auto-incrementa
        userId: 0, // API user
        companyId: apiKey.companyId,
        carat: carat,
        cut: body['cut'] as String,
        color: body['color'] as String,
        clarity: body['clarity'] as String,
        depth: (body['depth'] as num).toDouble(),
        table: (body['table'] as num).toDouble(),
        x: (body['x'] as num).toDouble(),
        y: (body['y'] as num).toDouble(),
        z: (body['z'] as num).toDouble(),
        predictedPrice: mockPrice,
        createdAt: DateTime.now(),
      );

      try {
        final saved = await _historyRepository.savePrediction(historyModel);
        return Right(
          ApiResponse.success(
            message: 'Prediction created successfully',
            data: _predictionToJson(saved),
          ),
        );
      } catch (e) {
        return Left(DatabaseFailure('Error saving prediction: $e'));
      }
    } catch (e) {
      return Left(ServerFailure('Error creating prediction: $e'));
    }
  }

  /// GET /api/v1/predictions/:id
  /// Busca uma previsão específica
  Future<Either<Failure, ApiResponse<Map<String, dynamic>>>> getPredictionById({
    required ApiKey apiKey,
    required String id,
  }) async {
    try {
      // Verificar permissão
      if (!apiKey.permissions.contains('read:predictions')) {
        return const Left(UnauthorizedFailure('Missing permission: read:predictions'));
      }

      // Buscar todas as previsões da empresa e filtrar por ID
      final predictions = await _historyRepository.getPredictionsForUser(
        0,
        companyId: apiKey.companyId,
      );

      final prediction = predictions.firstWhere(
        (p) => p.id.toString() == id,
        orElse: () => throw Exception('Prediction not found'),
      );

      // Verificar se pertence à empresa
      if (prediction.companyId != apiKey.companyId) {
        return const Left(UnauthorizedFailure('Access denied to this prediction'));
      }

      return Right(
        ApiResponse.success(
          data: _predictionToJson(prediction),
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Error fetching prediction: $e'));
    }
  }

  Map<String, dynamic> _predictionToJson(PredictionHistoryModel prediction) {
    return {
      'id': prediction.id,
      'carat': prediction.carat,
      'cut': prediction.cut,
      'color': prediction.color,
      'clarity': prediction.clarity,
      'depth': prediction.depth,
      'table': prediction.table,
      'x': prediction.x,
      'y': prediction.y,
      'z': prediction.z,
      'predicted_price': prediction.predictedPrice,
      'created_at': prediction.createdAt.toIso8601String(),
    };
  }

  String? _validatePredictionBody(Map<String, dynamic> body) {
    final required = ['carat', 'cut', 'color', 'clarity', 'depth', 'table', 'x', 'y', 'z'];
    
    for (final field in required) {
      if (!body.containsKey(field) || body[field] == null) {
        return 'Missing required field: $field';
      }
    }

    // Validar tipos numéricos
    final numFields = ['carat', 'depth', 'table', 'x', 'y', 'z'];
    for (final field in numFields) {
      if (body[field] is! num) {
        return 'Field $field must be a number';
      }
    }

    // Validar strings
    final strFields = ['cut', 'color', 'clarity'];
    for (final field in strFields) {
      if (body[field] is! String) {
        return 'Field $field must be a string';
      }
    }

    // Validar valores positivos
    if ((body['carat'] as num) <= 0) return 'Carat must be positive';
    if ((body['depth'] as num) <= 0) return 'Depth must be positive';
    if ((body['table'] as num) <= 0) return 'Table must be positive';
    if ((body['x'] as num) <= 0) return 'X must be positive';
    if ((body['y'] as num) <= 0) return 'Y must be positive';
    if ((body['z'] as num) <= 0) return 'Z must be positive';

    return null;
  }

  /// Cálculo de preço mockado para demonstração
  /// Em produção, seria substituído por modelo ML real
  double _calculateMockPrice(double carat, String cut, String color) {
    double basePrice = 5000 * carat;
    
    // Multiplicador por qualidade do corte
    final cutMultiplier = {
      'Ideal': 1.2,
      'Premium': 1.1,
      'Very Good': 1.0,
      'Good': 0.9,
      'Fair': 0.8,
    }[cut] ?? 1.0;
    
    // Multiplicador por cor
    final colorMultiplier = {
      'D': 1.3,
      'E': 1.25,
      'F': 1.2,
      'G': 1.15,
      'H': 1.1,
      'I': 1.05,
      'J': 1.0,
    }[color] ?? 1.0;
    
    return basePrice * cutMultiplier * colorMultiplier;
  }
}
