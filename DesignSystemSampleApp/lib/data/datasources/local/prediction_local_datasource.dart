import 'package:sqflite/sqflite.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/diamond_prediction_model.dart';
import 'database_helper.dart';

/// Interface do data source local
abstract class PredictionLocalDataSource {
  Future<void> savePrediction(
    DiamondPredictionModel prediction,
    int userId,
  );
  
  Future<List<PredictionHistoryModel>> getPredictionHistory(int userId);
  
  Future<void> clearHistory(int userId);
  
  Future<void> deletePrediction(int predictionId);
}

/// Implementação do data source local
class PredictionLocalDataSourceImpl implements PredictionLocalDataSource {
  final DatabaseHelper databaseHelper;

  PredictionLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> savePrediction(
    DiamondPredictionModel prediction,
    int userId,
  ) async {
    try {
      final db = await databaseHelper.database;
      
      final predictionMap = prediction.toMap();
      predictionMap['user_id'] = userId;
      
      await db.insert(
        'prediction_history',
        predictionMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Erro ao salvar predição: $e');
    }
  }

  @override
  Future<List<PredictionHistoryModel>> getPredictionHistory(int userId) async {
    try {
      final db = await databaseHelper.database;
      
      final maps = await db.query(
        'prediction_history',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'timestamp DESC',
      );

      return maps.map((map) => PredictionHistoryModel.fromMap(map)).toList();
    } catch (e) {
      throw CacheException('Erro ao buscar histórico: $e');
    }
  }

  @override
  Future<void> clearHistory(int userId) async {
    try {
      final db = await databaseHelper.database;
      
      await db.delete(
        'prediction_history',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      throw CacheException('Erro ao limpar histórico: $e');
    }
  }

  @override
  Future<void> deletePrediction(int predictionId) async {
    try {
      final db = await databaseHelper.database;
      
      await db.delete(
        'prediction_history',
        where: 'id = ?',
        whereArgs: [predictionId],
      );
    } catch (e) {
      throw CacheException('Erro ao deletar predição: $e');
    }
  }
}
