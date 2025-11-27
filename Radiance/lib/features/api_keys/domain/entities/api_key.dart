import 'package:equatable/equatable.dart';

/// Entidade de API Key
class ApiKey extends Equatable {
  final String id;
  final String companyId;
  final String name;
  final String keyHash;
  final String prefix; // Primeiros 8 caracteres para exibição
  final List<String> permissions;
  final bool isActive;
  final DateTime? lastUsedAt;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ApiKey({
    required this.id,
    required this.companyId,
    required this.name,
    required this.keyHash,
    required this.prefix,
    this.permissions = const [],
    this.isActive = true,
    this.lastUsedAt,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  
  bool get canBeUsed => isActive && !isExpired;

  String get displayKey => '$prefix...';

  ApiKey copyWith({
    String? id,
    String? companyId,
    String? name,
    String? keyHash,
    String? prefix,
    List<String>? permissions,
    bool? isActive,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ApiKey(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      name: name ?? this.name,
      keyHash: keyHash ?? this.keyHash,
      prefix: prefix ?? this.prefix,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        companyId,
        name,
        keyHash,
        prefix,
        permissions,
        isActive,
        lastUsedAt,
        expiresAt,
        createdAt,
        updatedAt,
      ];
}

/// Permissões disponíveis para API Keys
class ApiKeyPermission {
  static const String readPredictions = 'read:predictions';
  static const String writePredictions = 'write:predictions';
  static const String readCompany = 'read:company';
  static const String readUsers = 'read:users';
  static const String readAnalytics = 'read:analytics';

  static const List<String> all = [
    readPredictions,
    writePredictions,
    readCompany,
    readUsers,
    readAnalytics,
  ];

  static String getDisplayName(String permission) {
    switch (permission) {
      case readPredictions:
        return 'Ler Previsões';
      case writePredictions:
        return 'Criar Previsões';
      case readCompany:
        return 'Ler Dados da Empresa';
      case readUsers:
        return 'Ler Usuários';
      case readAnalytics:
        return 'Ler Analytics';
      default:
        return permission;
    }
  }

  static String getDescription(String permission) {
    switch (permission) {
      case readPredictions:
        return 'Permite listar e visualizar previsões';
      case writePredictions:
        return 'Permite criar novas previsões';
      case readCompany:
        return 'Permite acessar informações da empresa';
      case readUsers:
        return 'Permite listar membros da equipe';
      case readAnalytics:
        return 'Permite acessar métricas e relatórios';
      default:
        return '';
    }
  }
}
