import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import '../database/local_database.dart';
import '../database/web_storage.dart';
import '../models/prediction_model.dart';
import '../../constants/api_constants.dart';

/// Repositório para histórico de predições
/// Suporta tanto plataformas nativas (SQLite) quanto Web (memória)
class PredictionHistoryRepository {
  final LocalDatabase _localDatabase;
  final WebStorage _webStorage;

  PredictionHistoryRepository({LocalDatabase? localDatabase})
      : _localDatabase = localDatabase ?? LocalDatabase.instance,
        _webStorage = WebStorage.instance;

  /// Salva uma nova predição no histórico
  Future<PredictionHistoryModel> savePrediction(PredictionHistoryModel prediction) async {
    try {
      // Web: usar WebStorage
      if (kIsWeb) {
        return await _webStorage.savePrediction(prediction);
      }

      // Nativo: usar SQLite
      final db = await _localDatabase.database;
      
      final id = await db.insert(
        StorageConstants.predictionHistoryTable,
        prediction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return prediction.copyWith(id: id);
    } catch (e) {
      throw Exception('Erro ao salvar predição: ${e.toString()}');
    }
  }

  /// Obtém todas as predições de um usuário
  Future<List<PredictionHistoryModel>> getPredictionsForUser(int userId) async {
    try {
      // Web: usar WebStorage
      if (kIsWeb) {
        return await _webStorage.getPredictionsForUser(userId);
      }

      // Nativo: usar SQLite
      final db = await _localDatabase.database;
      
      final results = await db.query(
        StorageConstants.predictionHistoryTable,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      return results.map((map) => PredictionHistoryModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar histórico: ${e.toString()}');
    }
  }

  /// Obtém predições paginadas
  Future<List<PredictionHistoryModel>> getPaginatedPredictions({
    required int userId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      // Web: usar WebStorage
      if (kIsWeb) {
        return await _webStorage.getPaginatedPredictions(
          userId: userId,
          page: page,
          pageSize: pageSize,
        );
      }

      // Nativo: usar SQLite
      final db = await _localDatabase.database;
      final offset = (page - 1) * pageSize;
      
      final results = await db.query(
        StorageConstants.predictionHistoryTable,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
        limit: pageSize,
        offset: offset,
      );

      return results.map((map) => PredictionHistoryModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar histórico: ${e.toString()}');
    }
  }

  /// Conta o total de predições de um usuário
  Future<int> countPredictionsForUser(int userId) async {
    try {
      // Web: usar WebStorage
      if (kIsWeb) {
        return await _webStorage.countPredictionsForUser(userId);
      }

      // Nativo: usar SQLite
      final db = await _localDatabase.database;
      
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${StorageConstants.predictionHistoryTable} WHERE user_id = ?',
        [userId],
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Calcula o preço médio das predições
  Future<double> getAveragePrice(int userId) async {
    try {
      // Web: usar WebStorage
      if (kIsWeb) {
        return await _webStorage.getAveragePrice(userId);
      }

      // Nativo: usar SQLite
      final db = await _localDatabase.database;
      
      final result = await db.rawQuery(
        'SELECT AVG(predicted_price) as avg FROM ${StorageConstants.predictionHistoryTable} WHERE user_id = ?',
        [userId],
      );

      final avg = result.first['avg'];
      if (avg == null) return 0.0;
      return (avg as num).toDouble();
    } catch (e) {
      return 0.0;
    }
  }

  /// Obtém a última predição do usuário
  Future<PredictionHistoryModel?> getLastPrediction(int userId) async {
    try {
      // Web: usar WebStorage
      if (kIsWeb) {
        final predictions = await _webStorage.getPredictionsForUser(userId);
        return predictions.isNotEmpty ? predictions.first : null;
      }

      // Nativo: usar SQLite
      final db = await _localDatabase.database;
      
      final results = await db.query(
        StorageConstants.predictionHistoryTable,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
        limit: 1,
      );

      if (results.isEmpty) return null;
      return PredictionHistoryModel.fromMap(results.first);
    } catch (e) {
      return null;
    }
  }

  /// Remove uma predição do histórico
  Future<bool> deletePrediction(int predictionId) async {
    try {
      // Web: usar WebStorage
      if (kIsWeb) {
        return await _webStorage.deletePrediction(predictionId);
      }

      // Nativo: usar SQLite
      final db = await _localDatabase.database;
      
      final count = await db.delete(
        StorageConstants.predictionHistoryTable,
        where: 'id = ?',
        whereArgs: [predictionId],
      );

      return count > 0;
    } catch (e) {
      return false;
    }
  }

  /// Limpa todo o histórico de um usuário
  Future<bool> clearHistoryForUser(int userId) async {
    try {
      // Web: usar WebStorage
      if (kIsWeb) {
        return await _webStorage.clearHistoryForUser(userId);
      }

      // Nativo: usar SQLite
      final db = await _localDatabase.database;
      
      await db.delete(
        StorageConstants.predictionHistoryTable,
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtém estatísticas do usuário
  Future<UserPredictionStats> getStats(int userId) async {
    final totalPredictions = await countPredictionsForUser(userId);
    final averagePrice = await getAveragePrice(userId);
    final lastPrediction = await getLastPrediction(userId);

    return UserPredictionStats(
      totalPredictions: totalPredictions,
      averagePrice: averagePrice,
      lastPrediction: lastPrediction,
    );
  }
}

/// Estatísticas de predições do usuário
class UserPredictionStats {
  final int totalPredictions;
  final double averagePrice;
  final PredictionHistoryModel? lastPrediction;

  const UserPredictionStats({
    required this.totalPredictions,
    required this.averagePrice,
    this.lastPrediction,
  });

  double? get lastPredictionPrice => lastPrediction?.predictedPrice;
  
  bool get hasPredictions => totalPredictions > 0;
}
