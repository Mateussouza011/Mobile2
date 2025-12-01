import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/api_key.dart';
import '../../../../core/error/failures.dart';
import '../../../../data/datasources/local/database_helper.dart';

/// Repositório para gerenciar API Keys
class ApiKeyRepository {
  final DatabaseHelper _databaseHelper;

  ApiKeyRepository({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  /// Gera uma nova API Key
  String generateApiKey() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    final key = List.generate(32, (index) => chars[random.nextInt(chars.length)]).join();
    return 'rdk_$key'; // Radiance Development Key
  }

  /// Cria hash SHA256 da API key
  String hashApiKey(String apiKey) {
    final bytes = utf8.encode(apiKey);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Extrai o prefix da API key (primeiros 11 caracteres: rdk_xxxxxxx)
  String extractPrefix(String apiKey) {
    return apiKey.substring(0, min(11, apiKey.length));
  }

  /// Cria uma nova API Key
  Future<Either<Failure, ApiKey>> createApiKey({
    required String companyId,
    required String name,
    List<String>? permissions,
    DateTime? expiresAt,
  }) async {
    try {
      final db = await _databaseHelper.database;
      
      // Gerar chave
      final apiKey = generateApiKey();
      final keyHash = hashApiKey(apiKey);
      final prefix = extractPrefix(apiKey);

      final now = DateTime.now();
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      final data = {
        'id': id,
        'company_id': companyId,
        'name': name,
        'key_hash': keyHash,
        'prefix': prefix,
        'permissions': permissions?.join(',') ?? '',
        'is_active': 1,
        'expires_at': expiresAt?.toIso8601String(),
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      await db.insert('api_keys', data);

      final key = ApiKey(
        id: id,
        companyId: companyId,
        name: name,
        keyHash: keyHash,
        prefix: prefix,
        permissions: permissions ?? [],
        expiresAt: expiresAt,
        createdAt: now,
        updatedAt: now,
      );

      // Retornar a chave completa apenas uma vez
      return Right(key);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao criar API Key: $e'));
    }
  }

  /// Lista todas as API Keys de uma empresa
  Future<Either<Failure, List<ApiKey>>> getCompanyApiKeys(String companyId) async {
    try {
      final db = await _databaseHelper.database;
      
      final maps = await db.query(
        'api_keys',
        where: 'company_id = ?',
        whereArgs: [companyId],
        orderBy: 'created_at DESC',
      );

      final keys = maps.map((map) => _apiKeyFromMap(map)).toList();
      return Right(keys);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao listar API Keys: $e'));
    }
  }

  /// Busca API Key por ID
  Future<Either<Failure, ApiKey>> getApiKeyById(String id) async {
    try {
      final db = await _databaseHelper.database;
      
      final maps = await db.query(
        'api_keys',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        return const Left(NotFoundFailure('API Key não encontrada'));
      }

      return Right(_apiKeyFromMap(maps.first));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar API Key: $e'));
    }
  }

  /// Valida uma API Key pelo hash
  Future<Either<Failure, ApiKey>> validateApiKey(String apiKey) async {
    try {
      final db = await _databaseHelper.database;
      final keyHash = hashApiKey(apiKey);
      
      final maps = await db.query(
        'api_keys',
        where: 'key_hash = ? AND is_active = 1',
        whereArgs: [keyHash],
      );

      if (maps.isEmpty) {
        return const Left(UnauthorizedFailure('API Key inválida ou inativa'));
      }

      final key = _apiKeyFromMap(maps.first);

      if (key.isExpired) {
        return const Left(UnauthorizedFailure('API Key expirada'));
      }

      // Atualizar último uso
      await db.update(
        'api_keys',
        {'last_used_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [key.id],
      );

      return Right(key);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao validar API Key: $e'));
    }
  }

  /// Atualiza uma API Key
  Future<Either<Failure, void>> updateApiKey({
    required String id,
    String? name,
    List<String>? permissions,
    bool? isActive,
    DateTime? expiresAt,
  }) async {
    try {
      final db = await _databaseHelper.database;
      
      final data = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) data['name'] = name;
      if (permissions != null) data['permissions'] = permissions.join(',');
      if (isActive != null) data['is_active'] = isActive ? 1 : 0;
      if (expiresAt != null) data['expires_at'] = expiresAt.toIso8601String();

      final rowsAffected = await db.update(
        'api_keys',
        data,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        return const Left(NotFoundFailure('API Key não encontrada'));
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao atualizar API Key: $e'));
    }
  }

  /// Revoga uma API Key (desativa)
  Future<Either<Failure, void>> revokeApiKey(String id) async {
    return updateApiKey(id: id, isActive: false);
  }

  /// Deleta uma API Key
  Future<Either<Failure, void>> deleteApiKey(String id) async {
    try {
      final db = await _databaseHelper.database;
      
      final rowsAffected = await db.delete(
        'api_keys',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (rowsAffected == 0) {
        return const Left(NotFoundFailure('API Key não encontrada'));
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao deletar API Key: $e'));
    }
  }

  /// Conta API Keys ativas de uma empresa
  Future<Either<Failure, int>> countActiveKeys(String companyId) async {
    try {
      final db = await _databaseHelper.database;
      
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM api_keys WHERE company_id = ? AND is_active = 1',
        [companyId],
      );

      final count = Sqflite.firstIntValue(result) ?? 0;
      return Right(count);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao contar API Keys: $e'));
    }
  }

  ApiKey _apiKeyFromMap(Map<String, dynamic> map) {
    return ApiKey(
      id: map['id'] as String,
      companyId: map['company_id'] as String,
      name: map['name'] as String,
      keyHash: map['key_hash'] as String,
      prefix: map['prefix'] as String,
      permissions: (map['permissions'] as String?)?.split(',').where((p) => p.isNotEmpty).toList() ?? [],
      isActive: map['is_active'] == 1,
      lastUsedAt: map['last_used_at'] != null
          ? DateTime.parse(map['last_used_at'] as String)
          : null,
      expiresAt: map['expires_at'] != null
          ? DateTime.parse(map['expires_at'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
