import 'package:equatable/equatable.dart';

/// Entidade que representa uma empresa/organização no sistema multi-tenant
class Company extends Equatable {
  final String id;
  final String name;
  final String slug; // URL-friendly identifier
  final String? logo;
  final String? website;
  final String? description;
  final String ownerId; // User ID do proprietário
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  
  // Configurações da empresa
  final CompanySettings? settings;
  
  const Company({
    required this.id,
    required this.name,
    required this.slug,
    this.logo,
    this.website,
    this.description,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.settings,
  });

  Company copyWith({
    String? id,
    String? name,
    String? slug,
    String? logo,
    String? website,
    String? description,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    CompanySettings? settings,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      logo: logo ?? this.logo,
      website: website ?? this.website,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        logo,
        website,
        description,
        ownerId,
        createdAt,
        updatedAt,
        isActive,
        settings,
      ];
}

/// Configurações específicas da empresa
class CompanySettings extends Equatable {
  final String? primaryColor;
  final String? secondaryColor;
  final String? timezone;
  final String? currency;
  final String? language;
  final bool allowTeamInvites;
  final bool requireTwoFactor;
  final int maxUsers;
  
  const CompanySettings({
    this.primaryColor,
    this.secondaryColor,
    this.timezone = 'America/Sao_Paulo',
    this.currency = 'BRL',
    this.language = 'pt-BR',
    this.allowTeamInvites = true,
    this.requireTwoFactor = false,
    this.maxUsers = 5,
  });

  CompanySettings copyWith({
    String? primaryColor,
    String? secondaryColor,
    String? timezone,
    String? currency,
    String? language,
    bool? allowTeamInvites,
    bool? requireTwoFactor,
    int? maxUsers,
  }) {
    return CompanySettings(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      timezone: timezone ?? this.timezone,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      allowTeamInvites: allowTeamInvites ?? this.allowTeamInvites,
      requireTwoFactor: requireTwoFactor ?? this.requireTwoFactor,
      maxUsers: maxUsers ?? this.maxUsers,
    );
  }

  @override
  List<Object?> get props => [
        primaryColor,
        secondaryColor,
        timezone,
        currency,
        language,
        allowTeamInvites,
        requireTwoFactor,
        maxUsers,
      ];
}
