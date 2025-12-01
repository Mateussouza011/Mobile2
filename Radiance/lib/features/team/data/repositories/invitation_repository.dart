import 'package:dartz/dartz.dart';
import 'dart:math';
import '../../domain/entities/invitation.dart';
import '../../../../core/error/failures.dart';
import '../../../../data/datasources/local/database_helper.dart';

/// Repositório para gerenciar convites de equipe
class InvitationRepository {
  final DatabaseHelper _databaseHelper;

  InvitationRepository({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  /// Gera token único para convite
  String _generateToken() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(32, (_) => chars[random.nextInt(chars.length)]).join();
  }

  /// Cria um novo convite
  Future<Either<Failure, Invitation>> createInvitation({
    required String companyId,
    required String email,
    required String role,
    required String invitedBy,
    int validityDays = 7,
  }) async {
    try {
      final db = await _databaseHelper.database;

      // Verificar se já existe convite pendente para este email
      final existing = await db.query(
        'invitations',
        where: 'company_id = ? AND email = ? AND status = ?',
        whereArgs: [companyId, email, 'pending'],
      );

      if (existing.isNotEmpty) {
        return const Left(
          DatabaseFailure('Já existe um convite pendente para este email'),
        );
      }

      // Verificar se o email já é membro da empresa
      final member = await db.query(
        'company_users',
        where: 'company_id = ? AND email = ?',
        whereArgs: [companyId, email],
      );

      if (member.isNotEmpty) {
        return const Left(
          DatabaseFailure('Este email já é membro da empresa'),
        );
      }

      final now = DateTime.now();
      final token = _generateToken();
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      await db.insert('invitations', {
        'id': id,
        'company_id': companyId,
        'email': email,
        'role': role,
        'token': token,
        'status': 'pending',
        'created_at': now.toIso8601String(),
        'expires_at': now.add(Duration(days: validityDays)).toIso8601String(),
        'invited_by': invitedBy,
      });

      return Right(Invitation(
        id: id,
        companyId: companyId,
        email: email,
        role: role,
        token: token,
        status: InvitationStatus.pending,
        createdAt: now,
        expiresAt: now.add(Duration(days: validityDays)),
        invitedBy: invitedBy,
      ));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao criar convite: $e'));
    }
  }

  /// Lista convites da empresa
  Future<Either<Failure, List<Invitation>>> getCompanyInvitations(
    String companyId, {
    InvitationStatus? status,
  }) async {
    try {
      final db = await _databaseHelper.database;
      
      String where = 'company_id = ?';
      List<dynamic> whereArgs = [companyId];
      
      if (status != null) {
        where += ' AND status = ?';
        whereArgs.add(status.name);
      }

      final results = await db.query(
        'invitations',
        where: where,
        whereArgs: whereArgs,
        orderBy: 'created_at DESC',
      );

      final invitations = results.map((map) => _mapToInvitation(map)).toList();
      return Right(invitations);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar convites: $e'));
    }
  }

  /// Busca convite por token
  Future<Either<Failure, Invitation>> getInvitationByToken(
    String token,
  ) async {
    try {
      final db = await _databaseHelper.database;
      
      final results = await db.query(
        'invitations',
        where: 'token = ?',
        whereArgs: [token],
      );

      if (results.isEmpty) {
        return const Left(DatabaseFailure('Convite não encontrado'));
      }

      final invitation = _mapToInvitation(results.first);
      
      if (invitation.isExpired) {
        // Atualizar status para expirado
        await _updateStatus(invitation.id, InvitationStatus.expired);
        return const Left(DatabaseFailure('Convite expirado'));
      }

      return Right(invitation);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar convite: $e'));
    }
  }

  /// Aceita um convite
  Future<Either<Failure, void>> acceptInvitation(
    String invitationId,
    int userId,
  ) async {
    try {
      final db = await _databaseHelper.database;

      // Buscar convite
      final results = await db.query(
        'invitations',
        where: 'id = ?',
        whereArgs: [invitationId],
      );

      if (results.isEmpty) {
        return const Left(DatabaseFailure('Convite não encontrado'));
      }

      final invitation = _mapToInvitation(results.first);

      if (!invitation.isPending) {
        return const Left(DatabaseFailure('Convite não está mais pendente'));
      }

      // Atualizar convite
      await db.update(
        'invitations',
        {
          'status': 'accepted',
          'accepted_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [invitationId],
      );

      // Adicionar usuário à empresa
      await db.insert('company_users', {
        'company_id': invitation.companyId,
        'user_id': userId,
        'role': invitation.role,
        'email': invitation.email,
        'joined_at': DateTime.now().toIso8601String(),
      });

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao aceitar convite: $e'));
    }
  }

  /// Rejeita um convite
  Future<Either<Failure, void>> rejectInvitation(String invitationId) async {
    try {
      await _updateStatus(invitationId, InvitationStatus.rejected);
      
      final db = await _databaseHelper.database;
      await db.update(
        'invitations',
        {'rejected_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [invitationId],
      );

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao rejeitar convite: $e'));
    }
  }

  /// Cancela um convite
  Future<Either<Failure, void>> cancelInvitation(String invitationId) async {
    try {
      await _updateStatus(invitationId, InvitationStatus.cancelled);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao cancelar convite: $e'));
    }
  }

  /// Reenvia um convite (cria novo token e estende validade)
  Future<Either<Failure, Invitation>> resendInvitation(
    String invitationId,
  ) async {
    try {
      final db = await _databaseHelper.database;
      
      final results = await db.query(
        'invitations',
        where: 'id = ?',
        whereArgs: [invitationId],
      );

      if (results.isEmpty) {
        return const Left(DatabaseFailure('Convite não encontrado'));
      }

      final invitation = _mapToInvitation(results.first);

      if (!invitation.canBeResent) {
        return const Left(DatabaseFailure('Este convite não pode ser reenviado'));
      }

      final newToken = _generateToken();
      final newExpiry = DateTime.now().add(const Duration(days: 7));

      await db.update(
        'invitations',
        {
          'token': newToken,
          'status': 'pending',
          'expires_at': newExpiry.toIso8601String(),
          'created_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [invitationId],
      );

      return Right(invitation.copyWith(
        token: newToken,
        status: InvitationStatus.pending,
        expiresAt: newExpiry,
        createdAt: DateTime.now(),
      ));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao reenviar convite: $e'));
    }
  }

  /// Exclui um convite
  Future<Either<Failure, void>> deleteInvitation(String invitationId) async {
    try {
      final db = await _databaseHelper.database;
      
      await db.delete(
        'invitations',
        where: 'id = ?',
        whereArgs: [invitationId],
      );

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao excluir convite: $e'));
    }
  }

  /// Atualiza status do convite
  Future<void> _updateStatus(
    String invitationId,
    InvitationStatus status,
  ) async {
    final db = await _databaseHelper.database;
    await db.update(
      'invitations',
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [invitationId],
    );
  }

  /// Mapeia resultado do banco para Invitation
  Invitation _mapToInvitation(Map<String, dynamic> map) {
    return Invitation(
      id: map['id'] as String,
      companyId: map['company_id'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      token: map['token'] as String,
      status: InvitationStatus.fromString(map['status'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      expiresAt: DateTime.parse(map['expires_at'] as String),
      invitedBy: map['invited_by'] as String?,
      acceptedAt: map['accepted_at'] != null
          ? DateTime.parse(map['accepted_at'] as String)
          : null,
      rejectedAt: map['rejected_at'] != null
          ? DateTime.parse(map['rejected_at'] as String)
          : null,
    );
  }
}
