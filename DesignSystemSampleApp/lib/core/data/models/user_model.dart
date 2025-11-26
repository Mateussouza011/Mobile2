/// Modelo de Usuário para o sistema de autenticação
/// 
/// Armazena informações do usuário no banco de dados local.
class User {
  final int? id;
  final String fullName;
  final String username;
  final DateTime birthDate;
  final String passwordHash;
  final DateTime createdAt;
  
  User({
    this.id,
    required this.fullName,
    required this.username,
    required this.birthDate,
    required this.passwordHash,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  
  /// Converte para Map para salvar no banco
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'birth_date': birthDate.toIso8601String(),
      'password_hash': passwordHash,
      'created_at': createdAt.toIso8601String(),
    };
  }
  
  /// Cria um User a partir de um Map do banco
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      fullName: map['full_name'] as String,
      username: map['username'] as String,
      birthDate: DateTime.parse(map['birth_date'] as String),
      passwordHash: map['password_hash'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
  
  /// Cria cópia com novos valores
  User copyWith({
    int? id,
    String? fullName,
    String? username,
    DateTime? birthDate,
    String? passwordHash,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      birthDate: birthDate ?? this.birthDate,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  /// Formata a data de nascimento
  String get formattedBirthDate {
    return '${birthDate.day.toString().padLeft(2, '0')}/'
           '${birthDate.month.toString().padLeft(2, '0')}/'
           '${birthDate.year}';
  }
}
