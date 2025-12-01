import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/company.dart';
import '../../domain/entities/company_user.dart';
import '../../domain/entities/subscription.dart';
import '../../../../core/error/failures.dart';
import '../../../../data/datasources/local/database_helper.dart';

/// Repository para operações relacionadas a empresas
class CompanyRepository {
  final DatabaseHelper _databaseHelper;

  CompanyRepository(this._databaseHelper);

  /// Cria uma nova empresa
  Future<Either<Failure, Company>> createCompany(Company company) async {
    try {
      final db = await _databaseHelper.database;
      
      await db.insert(
        'companies',
        _companyToMap(company),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      return Right(company);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao criar empresa: $e'));
    }
  }

  /// Busca empresa por ID
  Future<Either<Failure, Company>> getCompanyById(String id) async {
    try {
      final db = await _databaseHelper.database;
      
      final results = await db.query(
        'companies',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) {
        return const Left(NotFoundFailure('Empresa não encontrada'));
      }

      return Right(_companyFromMap(results.first));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar empresa: $e'));
    }
  }

  /// Busca empresa por slug
  Future<Either<Failure, Company>> getCompanyBySlug(String slug) async {
    try {
      final db = await _databaseHelper.database;
      
      final results = await db.query(
        'companies',
        where: 'slug = ?',
        whereArgs: [slug],
        limit: 1,
      );

      if (results.isEmpty) {
        return const Left(NotFoundFailure('Empresa não encontrada'));
      }

      return Right(_companyFromMap(results.first));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar empresa: $e'));
    }
  }

  /// Lista empresas de um usuário
  Future<Either<Failure, List<Company>>> getUserCompanies(String userId) async {
    try {
      final db = await _databaseHelper.database;
      
      final results = await db.rawQuery('''
        SELECT DISTINCT c.* 
        FROM companies c
        INNER JOIN company_users cu ON c.id = cu.company_id
        WHERE cu.user_id = ? AND cu.status = 'active' AND c.is_active = 1
        ORDER BY c.created_at DESC
      ''', [userId]);

      final companies = results.map((map) => _companyFromMap(map)).toList();
      return Right(companies);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao listar empresas: $e'));
    }
  }

  /// Atualiza uma empresa
  Future<Either<Failure, Company>> updateCompany(Company company) async {
    try {
      final db = await _databaseHelper.database;
      
      final updatedCompany = company.copyWith(
        updatedAt: DateTime.now(),
      );

      await db.update(
        'companies',
        _companyToMap(updatedCompany),
        where: 'id = ?',
        whereArgs: [company.id],
      );

      return Right(updatedCompany);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao atualizar empresa: $e'));
    }
  }

  /// Desativa uma empresa (soft delete)
  Future<Either<Failure, void>> deactivateCompany(String id) async {
    try {
      final db = await _databaseHelper.database;
      
      await db.update(
        'companies',
        {
          'is_active': 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao desativar empresa: $e'));
    }
  }

  /// Busca assinatura da empresa
  Future<Either<Failure, Subscription>> getCompanySubscription(String companyId) async {
    try {
      final db = await _databaseHelper.database;
      
      final results = await db.query(
        'subscriptions',
        where: 'company_id = ?',
        whereArgs: [companyId],
        orderBy: 'created_at DESC',
        limit: 1,
      );

      if (results.isEmpty) {
        return const Left(NotFoundFailure('Assinatura não encontrada'));
      }

      return Right(_subscriptionFromMap(results.first));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar assinatura: $e'));
    }
  }

  /// Lista membros da empresa
  Future<Either<Failure, List<CompanyUser>>> getCompanyMembers(String companyId) async {
    try {
      final db = await _databaseHelper.database;
      
      final results = await db.query(
        'company_users',
        where: 'company_id = ?',
        whereArgs: [companyId],
        orderBy: 'joined_at ASC',
      );

      final members = results.map((map) => _companyUserFromMap(map)).toList();
      return Right(members);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao listar membros: $e'));
    }
  }

  /// Adiciona membro à empresa
  Future<Either<Failure, CompanyUser>> addCompanyMember(CompanyUser member) async {
    try {
      final db = await _databaseHelper.database;
      
      await db.insert(
        'company_users',
        _companyUserToMap(member),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      return Right(member);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao adicionar membro: $e'));
    }
  }

  /// Atualiza role de um membro
  Future<Either<Failure, void>> updateMemberRole(
    String companyId,
    String userId,
    String newRoleId,
  ) async {
    try {
      final db = await _databaseHelper.database;
      
      await db.update(
        'company_users',
        {
          'role_id': newRoleId,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'company_id = ? AND user_id = ?',
        whereArgs: [companyId, userId],
      );

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao atualizar role: $e'));
    }
  }

  /// Remove membro da empresa
  Future<Either<Failure, void>> removeMember(
    String companyId,
    String userId,
  ) async {
    try {
      final db = await _databaseHelper.database;
      
      await db.update(
        'company_users',
        {
          'status': 'inactive',
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'company_id = ? AND user_id = ?',
        whereArgs: [companyId, userId],
      );

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao remover membro: $e'));
    }
  }

  // ============================================
  // Métodos auxiliares de conversão
  // ============================================

  Map<String, dynamic> _companyToMap(Company company) {
    return {
      'id': company.id,
      'name': company.name,
      'slug': company.slug,
      'logo': company.logo,
      'website': company.website,
      'description': company.description,
      'owner_id': company.ownerId,
      'created_at': company.createdAt.toIso8601String(),
      'updated_at': company.updatedAt.toIso8601String(),
      'is_active': company.isActive ? 1 : 0,
      'settings': company.settings != null ? jsonEncode(_settingsToMap(company.settings!)) : null,
    };
  }

  Company _companyFromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'] as String,
      name: map['name'] as String,
      slug: map['slug'] as String,
      logo: map['logo'] as String?,
      website: map['website'] as String?,
      description: map['description'] as String?,
      ownerId: map['owner_id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      isActive: (map['is_active'] as int) == 1,
      settings: map['settings'] != null 
        ? _settingsFromMap(jsonDecode(map['settings'] as String))
        : null,
    );
  }

  Map<String, dynamic> _settingsToMap(CompanySettings settings) {
    return {
      'primaryColor': settings.primaryColor,
      'secondaryColor': settings.secondaryColor,
      'timezone': settings.timezone,
      'currency': settings.currency,
      'language': settings.language,
      'allowTeamInvites': settings.allowTeamInvites,
      'requireTwoFactor': settings.requireTwoFactor,
      'maxUsers': settings.maxUsers,
    };
  }

  CompanySettings _settingsFromMap(Map<String, dynamic> map) {
    return CompanySettings(
      primaryColor: map['primaryColor'] as String?,
      secondaryColor: map['secondaryColor'] as String?,
      timezone: map['timezone'] as String? ?? 'America/Sao_Paulo',
      currency: map['currency'] as String? ?? 'BRL',
      language: map['language'] as String? ?? 'pt-BR',
      allowTeamInvites: map['allowTeamInvites'] as bool? ?? true,
      requireTwoFactor: map['requireTwoFactor'] as bool? ?? false,
      maxUsers: map['maxUsers'] as int? ?? 5,
    );
  }

  Map<String, dynamic> _companyUserToMap(CompanyUser member) {
    return {
      'id': member.id,
      'company_id': member.companyId,
      'user_id': member.userId,
      'role_id': member.roleId,
      'status': member.status.name,
      'joined_at': member.joinedAt.toIso8601String(),
      'invited_at': member.invitedAt?.toIso8601String(),
      'invited_by': member.invitedBy,
      'last_access_at': member.lastAccessAt?.toIso8601String(),
      'updated_at': member.updatedAt.toIso8601String(),
    };
  }

  CompanyUser _companyUserFromMap(Map<String, dynamic> map) {
    return CompanyUser(
      id: map['id'] as String,
      companyId: map['company_id'] as String,
      userId: map['user_id'] as String,
      roleId: map['role_id'] as String,
      status: CompanyUserStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => CompanyUserStatus.active,
      ),
      joinedAt: DateTime.parse(map['joined_at'] as String),
      invitedAt: map['invited_at'] != null ? DateTime.parse(map['invited_at'] as String) : null,
      invitedBy: map['invited_by'] as String?,
      lastAccessAt: map['last_access_at'] != null ? DateTime.parse(map['last_access_at'] as String) : null,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Subscription _subscriptionFromMap(Map<String, dynamic> map) {
    final tier = SubscriptionTier.values.firstWhere(
      (e) => e.name == map['tier'],
      orElse: () => SubscriptionTier.free,
    );

    final limits = SubscriptionLimits(
      maxPredictionsPerMonth: map['max_predictions_per_month'] as int,
      maxUsers: map['max_users'] as int,
      hasApiAccess: (map['has_api_access'] as int) == 1,
      hasExportFeatures: (map['has_export_features'] as int) == 1,
      hasAdvancedAnalytics: (map['has_advanced_analytics'] as int) == 1,
      hasWhiteLabel: (map['has_white_label'] as int) == 1,
      hasPrioritySupport: (map['has_priority_support'] as int) == 1,
    );

    return Subscription(
      id: map['id'] as String,
      companyId: map['company_id'] as String,
      tier: tier,
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => SubscriptionStatus.active,
      ),
      billingInterval: BillingInterval.values.firstWhere(
        (e) => e.name == map['billing_interval'],
        orElse: () => BillingInterval.monthly,
      ),
      amount: map['amount'] as double,
      currency: map['currency'] as String? ?? 'BRL',
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date'] as String) : null,
      trialEndsAt: map['trial_ends_at'] != null ? DateTime.parse(map['trial_ends_at'] as String) : null,
      cancelledAt: map['cancelled_at'] != null ? DateTime.parse(map['cancelled_at'] as String) : null,
      currentPeriodStart: DateTime.parse(map['current_period_start'] as String),
      currentPeriodEnd: DateTime.parse(map['current_period_end'] as String),
      nextBillingDate: map['next_billing_date'] != null ? DateTime.parse(map['next_billing_date'] as String) : null,
      limits: limits,
      abacatePaySubscriptionId: map['abacate_pay_subscription_id'] as String?,
      abacatePayCustomerId: map['abacate_pay_customer_id'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
