import 'package:equatable/equatable.dart';

/// Status do convite
enum InvitationStatus {
  pending,
  accepted,
  rejected,
  expired,
  cancelled;

  String get displayName {
    switch (this) {
      case InvitationStatus.pending:
        return 'Pendente';
      case InvitationStatus.accepted:
        return 'Aceito';
      case InvitationStatus.rejected:
        return 'Rejeitado';
      case InvitationStatus.expired:
        return 'Expirado';
      case InvitationStatus.cancelled:
        return 'Cancelado';
    }
  }

  static InvitationStatus fromString(String status) {
    return InvitationStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => InvitationStatus.pending,
    );
  }
}

/// Convite para membro da equipe
class Invitation extends Equatable {
  final String id;
  final String companyId;
  final String email;
  final String role;
  final String token;
  final InvitationStatus status;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? invitedBy;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;

  const Invitation({
    required this.id,
    required this.companyId,
    required this.email,
    required this.role,
    required this.token,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    this.invitedBy,
    this.acceptedAt,
    this.rejectedAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isPending => status == InvitationStatus.pending && !isExpired;
  bool get canBeResent => status == InvitationStatus.pending || 
                         status == InvitationStatus.expired;

  String get statusDisplayWithExpiry {
    if (isExpired && status == InvitationStatus.pending) {
      return InvitationStatus.expired.displayName;
    }
    return status.displayName;
  }

  Invitation copyWith({
    String? id,
    String? companyId,
    String? email,
    String? role,
    String? token,
    InvitationStatus? status,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? invitedBy,
    DateTime? acceptedAt,
    DateTime? rejectedAt,
  }) {
    return Invitation(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      invitedBy: invitedBy ?? this.invitedBy,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        companyId,
        email,
        role,
        token,
        status,
        createdAt,
        expiresAt,
        invitedBy,
        acceptedAt,
        rejectedAt,
      ];
}
