import 'package:equatable/equatable.dart';

/// Entidade de domínio que representa um usuário do sistema
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? phone;
  final bool isAdmin; // Super admin do sistema (acesso global)
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  
  // Contexto multi-tenant (empresa atual do usuário)
  final String? currentCompanyId;
  final String? currentRoleId;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.phone,
    this.isAdmin = false,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.currentCompanyId,
    this.currentRoleId,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? phone,
    bool? isAdmin,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? currentCompanyId,
    String? currentRoleId,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
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
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        phone,
        isAdmin,
        createdAt,
        updatedAt,
        isActive,
        currentCompanyId,
        currentRoleId,
      ];
}
