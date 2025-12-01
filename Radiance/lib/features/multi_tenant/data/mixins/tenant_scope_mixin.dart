/// Mixin para adicionar suporte a row-level security (isolamento por tenant)
/// nos repositories
mixin TenantScopeMixin {
  /// Adiciona filtro de company_id ao where clause
  String addTenantFilter(String? existingWhere, String? companyId) {
    if (companyId == null) return existingWhere ?? '';
    
    const tenantFilter = 'company_id = ?';
    
    if (existingWhere == null || existingWhere.isEmpty) {
      return tenantFilter;
    }
    
    return '$existingWhere AND $tenantFilter';
  }

  /// Adiciona company_id aos whereArgs
  List<dynamic> addTenantArgs(List<dynamic>? existingArgs, String? companyId) {
    if (companyId == null) return existingArgs ?? [];
    
    final args = existingArgs?.toList() ?? [];
    args.add(companyId);
    return args;
  }

  /// Valida se uma query deve incluir filtro de tenant
  bool shouldFilterByTenant(String? companyId) {
    return companyId != null && companyId.isNotEmpty;
  }
}

/// Extensão para facilitar uso de tenant scope em queries
extension TenantQueryExtension on Map<String, dynamic> {
  /// Adiciona company_id ao mapa se fornecido
  Map<String, dynamic> withTenant(String? companyId) {
    if (companyId != null && companyId.isNotEmpty) {
      return {...this, 'company_id': companyId};
    }
    return this;
  }
}
