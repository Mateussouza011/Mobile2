import 'package:flutter/foundation.dart' show kIsWeb;

/// Serviço de Banco de Dados Local
/// 
/// Para WEB: usa armazenamento em memória
/// Para Mobile/Desktop: usaria SQLite (não implementado ainda)
class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  
  // Armazenamento em memória para web
  final Map<String, List<Map<String, dynamic>>> _memoryDb = {
    'users': [],
  };
  
  int _autoIncrementId = 1;
  
  DatabaseService._internal();
  
  /// Insere um registro na tabela
  Future<int> insert(String table, Map<String, dynamic> data) async {
    if (kIsWeb) {
      // Web: armazenamento em memória
      final record = Map<String, dynamic>.from(data);
      record['id'] = _autoIncrementId++;
      _memoryDb[table]?.add(record);
      return record['id'] as int;
    } else {
      // TODO: Implementar SQLite para mobile/desktop
      throw UnimplementedError('SQLite não implementado para esta plataforma');
    }
  }
  
  /// Busca registros na tabela
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    if (kIsWeb) {
      final records = _memoryDb[table] ?? [];
      
      if (where == null || whereArgs == null) {
        return List.from(records);
      }
      
      // Parsing simples para "column = ?"
      final match = RegExp(r'(\w+)\s*=\s*\?').firstMatch(where);
      if (match != null) {
        final column = match.group(1);
        final value = whereArgs.first;
        return records.where((r) => r[column] == value).toList();
      }
      
      return List.from(records);
    } else {
      throw UnimplementedError('SQLite não implementado para esta plataforma');
    }
  }
  
  /// Atualiza registros na tabela
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    if (kIsWeb) {
      final records = _memoryDb[table] ?? [];
      int count = 0;
      
      if (where != null && whereArgs != null) {
        final match = RegExp(r'(\w+)\s*=\s*\?').firstMatch(where);
        if (match != null) {
          final column = match.group(1);
          final value = whereArgs.first;
          
          for (var record in records) {
            if (record[column] == value) {
              record.addAll(data);
              count++;
            }
          }
        }
      }
      
      return count;
    } else {
      throw UnimplementedError('SQLite não implementado para esta plataforma');
    }
  }
  
  /// Deleta registros da tabela
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    if (kIsWeb) {
      final records = _memoryDb[table] ?? [];
      
      if (where == null) {
        final count = records.length;
        records.clear();
        return count;
      }
      
      final match = RegExp(r'(\w+)\s*=\s*\?').firstMatch(where);
      if (match != null) {
        final column = match.group(1);
        final value = whereArgs?.first;
        final before = records.length;
        records.removeWhere((r) => r[column] == value);
        return before - records.length;
      }
      
      return 0;
    } else {
      throw UnimplementedError('SQLite não implementado para esta plataforma');
    }
  }
  
  /// Fecha a conexão (no-op para memória)
  Future<void> close() async {
    // No-op para armazenamento em memória
  }
  
  /// Limpa todos os dados
  Future<void> clearAll() async {
    for (var table in _memoryDb.keys) {
      _memoryDb[table]?.clear();
    }
    _autoIncrementId = 1;
  }
}
