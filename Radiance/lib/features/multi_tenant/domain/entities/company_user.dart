import 'package:equatable/equatable.dart';

/// Status do convite/membro na empresa
enum CompanyUserStatus {
  pending,    // Convite enviado, aguardando aceitação
  active,     // Membro ativo
  suspended,  // Temporariamente suspenso
  inactive,   // Inativo (saiu ou foi removido)
}

/// Entidade que representa a relação entre um usuário e uma empresa
class CompanyUser extends Equatable {
  final String id;
  final String companyId;
  final String userId;
  final String roleId;
  final CompanyUserStatus status;
  final DateTime joinedAt;
  final DateTime? invitedAt;
  final String? invitedBy; // User ID de quem convidou
  final DateTime? lastAccessAt;
  final DateTime updatedAt;

  const CompanyUser({
    required this.id,
    required this.companyId,
    required this.userId,
    required this.roleId,
    this.status = CompanyUserStatus.active,
    required this.joinedAt,
    this.invitedAt,
    this.invitedBy,
    this.lastAccessAt,
    required this.updatedAt,
  });

  bool get isActive => status == CompanyUserStatus.active;
  bool get isPending => status == CompanyUserStatus.pending;
  bool get isSuspended => status == CompanyUserStatus.suspended;

  CompanyUser copyWith({
    String? id,
    String? companyId,
    String? userId,
    String? roleId,
    CompanyUserStatus? status,
    DateTime? joinedAt,
    DateTime? invitedAt,
    String? invitedBy,
    DateTime? lastAccessAt,
    DateTime? updatedAt,
  }) {
    return CompanyUser(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      invitedAt: invitedAt ?? this.invitedAt,
      invitedBy: invitedBy ?? this.invitedBy,
      lastAccessAt: lastAccessAt ?? this.lastAccessAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        companyId,
        userId,
        roleId,
        status,
        joinedAt,
        invitedAt,
        invitedBy,
        lastAccessAt,
        updatedAt,
      ];
}

/// Entidade para convites pendentes
class CompanyInvitation extends Equatable {
  final String id;
  final String companyId;
  final String email;
  final String roleId;
  final String invitedBy; // User ID
  final DateTime invitedAt;
  final DateTime expiresAt;
  final String? token; // Token único para aceitar o convite
  final bool isAccepted;
  final DateTime? acceptedAt;

  const CompanyInvitation({
    required this.id,
    required this.companyId,
    required this.email,
    required this.roleId,
    required this.invitedBy,
    required this.invitedAt,
    required this.expiresAt,
    this.token,
    this.isAccepted = false,
    this.acceptedAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isValid => !isExpired && !isAccepted;

  CompanyInvitation copyWith({
    String? id,
    String? companyId,
    String? email,
    String? roleId,
    String? invitedBy,
    DateTime? invitedAt,
    DateTime? expiresAt,
    String? token,
    bool? isAccepted,
    DateTime? acceptedAt,
  }) {
    return CompanyInvitation(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      email: email ?? this.email,
      roleId: roleId ?? this.roleId,
      invitedBy: invitedBy ?? this.invitedBy,
      invitedAt: invitedAt ?? this.invitedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      token: token ?? this.token,
      isAccepted: isAccepted ?? this.isAccepted,
      acceptedAt: acceptedAt ?? this.acceptedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        companyId,
        email,
        roleId,
        invitedBy,
        invitedAt,
        expiresAt,
        token,
        isAccepted,
        acceptedAt,
      ];
}
