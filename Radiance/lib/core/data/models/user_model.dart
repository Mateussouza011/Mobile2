/// Modelo de usuário para autenticação local
class UserModel {
  final int? id;
  final String name;
  final String email;
  final String passwordHash;
  final String? avatarUrl;
  final String? phone;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  
  // Contexto multi-tenant
  final String? currentCompanyId;
  final String? currentRoleId;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.avatarUrl,
    this.phone,
    this.isAdmin = false,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.currentCompanyId,
    this.currentRoleId,
  });

  /// Cria uma instância de UserModel a partir de um Map (do SQLite)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      passwordHash: map['password_hash'] as String,
      avatarUrl: map['avatar_url'] as String?,
      phone: map['phone'] as String?,
      isAdmin: (map['is_admin'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at'] as String) 
          : null,
      isActive: (map['is_active'] as int?) != 0,
      currentCompanyId: map['current_company_id'] as String?,
      currentRoleId: map['current_role_id'] as String?,
    );
  }

  /// Converte o UserModel para Map (para inserção no SQLite)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'password_hash': passwordHash,
      'avatar_url': avatarUrl,
      'phone': phone,
      'is_admin': isAdmin ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'current_company_id': currentCompanyId,
      'current_role_id': currentRoleId,
    };
  }

  /// Copia o modelo com novas propriedades
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? passwordHash,
    String? avatarUrl,
    String? phone,
    bool? isAdmin,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? currentCompanyId,
    String? currentRoleId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      currentCompanyId: currentCompanyId ?? this.currentCompanyId,
      currentRoleId: currentRoleId ?? this.currentRoleId,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
