# Admin Panel - Radiance B2B Professional

## Visão Geral

O Admin Panel é um módulo completo para gerenciamento do sistema B2B SaaS, permitindo administradores controlarem empresas, usuários, assinaturas e visualizarem métricas do sistema.

## Funcionalidades

### 📊 Dashboard de Métricas
- **Visão Geral**: KPIs principais (usuários, empresas, MRR, receita)
- **Receita**: Gráficos de receita diária/mensal, MRR histórico
- **Crescimento**: Signups, usuários ativos, taxa de crescimento
- **Saúde do Sistema**: Score de saúde, alertas críticos, warnings

### 🏢 Gerenciamento de Empresas
- Listagem com filtros avançados
- Detalhes completos da empresa
- Ativação/desativação
- Estatísticas por empresa (usuários, predições, receita)

### 👥 Gerenciamento de Usuários
- Listagem com busca e filtros
- Alteração de roles
- Ativação/desativação
- Logs de atividade
- Transferência entre empresas

### 💳 Gerenciamento de Assinaturas
- Visão geral de assinaturas
- Upgrade/downgrade de tier
- Cancelamento e reativação
- Suspensão
- Processamento de reembolsos
- Métricas de MRR

### 📋 Logs de Auditoria
- Registro de todas as ações
- Filtros por entidade, ação, data
- Paginação infinita
- Exportação para CSV
- Estatísticas de auditoria

## Arquitetura

```
lib/features/admin/
├── data/
│   └── repositories/
│       ├── admin_audit_repository.dart
│       ├── admin_company_repository.dart
│       ├── admin_metrics_repository.dart
│       ├── admin_subscription_repository.dart
│       └── admin_user_repository.dart
├── domain/
│   └── entities/
│       ├── admin_audit_log.dart
│       ├── admin_company_stats.dart
│       ├── admin_metrics_stats.dart
│       ├── admin_subscription_stats.dart
│       └── admin_user_stats.dart
└── presentation/
    ├── pages/
    │   ├── admin_audit_logs_page.dart
    │   ├── admin_companies_page.dart
    │   ├── admin_dashboard_page.dart
    │   ├── admin_subscriptions_page.dart
    │   └── admin_users_page.dart
    └── providers/
        ├── admin_audit_provider.dart
        ├── admin_company_provider.dart
        ├── admin_metrics_provider.dart
        ├── admin_subscription_provider.dart
        └── admin_user_provider.dart
```

## Entidades

### AdminAuditLog
```dart
class AdminAuditLog {
  final String id;
  final AuditEntityType entityType;
  final String entityId;
  final AuditAction action;
  final String performedBy;
  final String? performedByName;
  final Map<String, dynamic>? details;
  final DateTime timestamp;
}
```

### AdminCompanyStats
```dart
class AdminCompanyStats {
  final Company company;
  final Subscription? subscription;
  final int totalUsers;
  final int activeUsers;
  final int predictionsThisMonth;
  final double totalRevenue;
  final DateTime? lastActivityAt;
}
```

### AdminSubscriptionStats
```dart
class AdminSubscriptionStats {
  final Subscription subscription;
  final Company company;
  final List<PaymentRecord> paymentHistory;
  final double totalRevenue;
  final double monthlyRecurringRevenue;
  final int daysUntilRenewal;
  final bool isOverdue;
}
```

### AdminUserStats
```dart
class AdminUserStats {
  final User user;
  final Company? company;
  final String? subscriptionTier;
  final int predictionsThisMonth;
  final int totalPredictions;
  final DateTime? lastActiveAt;
}
```

### SystemMetrics
```dart
class SystemMetrics {
  final int totalUsers;
  final int activeUsers;
  final int totalCompanies;
  final double totalRevenue;
  final double monthlyRecurringRevenue;
  final double systemHealthScore;
  // ... mais campos
}
```

## Providers

### AdminMetricsProvider
Gerencia métricas do sistema com carregamento paralelo e refresh.

```dart
final provider = AdminMetricsProvider(repository);
await provider.loadAllMetrics();
print(provider.totalUsers);
print(provider.mrr);
print(provider.healthScore);
```

### AdminCompanyProvider
Gerencia empresas com filtros, busca e CRUD.

```dart
final provider = AdminCompanyProvider(repository);
await provider.loadCompanies();
await provider.searchCompanies('Acme');
await provider.toggleCompanyStatus('company-id', true, 'admin-id');
```

### AdminSubscriptionProvider
Gerencia assinaturas com ações de lifecycle.

```dart
final provider = AdminSubscriptionProvider(repository);
await provider.loadSubscriptions();
await provider.updateSubscriptionTier('sub-id', SubscriptionTier.pro, 'admin-id', 'Upgrade');
await provider.cancelSubscription('sub-id', 'admin-id', 'Reason');
```

### AdminUserProvider
Gerencia usuários com alteração de roles e logs.

```dart
final provider = AdminUserProvider(repository);
await provider.loadUsers();
await provider.changeUserRole('user-id', UserRole.admin, 'admin-id');
await provider.toggleUserStatus('user-id', true, 'admin-id');
```

### AdminAuditProvider
Gerencia logs de auditoria com paginação.

```dart
final provider = AdminAuditProvider(repository);
await provider.loadLogs();
await provider.loadMore(); // Paginação infinita
await provider.exportToCSV();
```

## Filtros

### CompanyFilters
```dart
const filters = CompanyFilters(
  searchQuery: 'acme',
  subscriptionTier: SubscriptionTier.pro,
  isActive: true,
  sortBy: CompanySortBy.name,
  sortAscending: true,
);
```

### UserFilters
```dart
const filters = UserFilters(
  searchQuery: 'john',
  role: UserRole.admin,
  isActive: true,
);
```

### AuditLogFilters
```dart
const filters = AuditLogFilters(
  entityType: AuditEntityType.user,
  action: AuditAction.update,
  startDate: DateTime(2024, 1, 1),
  endDate: DateTime(2024, 12, 31),
);
```

### SubscriptionFilters
```dart
const filters = SubscriptionFilters(
  tier: SubscriptionTier.enterprise,
  status: SubscriptionStatus.active,
  sortBy: SubscriptionSortBy.createdAt,
);
```

## Páginas

### AdminDashboardPage
Dashboard principal com 4 abas:
- Visão Geral
- Receita
- Crescimento
- Saúde

### AdminCompaniesPage
Lista de empresas com:
- Barra de busca
- Filtros (tier, status)
- Cards com estatísticas
- Modal de detalhes

### AdminUsersPage
Lista de usuários com:
- Busca por nome/email
- Filtros (role, status)
- Ações rápidas (role, status)
- Modal de detalhes e logs

### AdminSubscriptionsPage
Lista de assinaturas com:
- Busca por empresa
- Filtros (tier, status)
- Ações (upgrade, cancel, suspend)
- Modal com histórico de pagamentos

### AdminAuditLogsPage
Lista de logs com:
- Busca
- Filtros avançados
- Scroll infinito
- Exportação CSV
- Estatísticas

## Testes

### Cobertura
- **Repositórios**: 133 testes
- **Providers**: 175 testes
- **Total**: 308+ testes

### Executar Testes
```bash
# Todos os testes admin
flutter test test/domain/repositories/admin/ test/presentation/providers/

# Repositórios apenas
flutter test test/domain/repositories/admin/

# Providers apenas
flutter test test/presentation/providers/
```

## Integração

### Registro de Providers
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => AdminMetricsProvider(
        AdminMetricsRepository(databaseHelper),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => AdminCompanyProvider(
        repository: AdminCompanyRepository(databaseHelper),
      ),
    ),
    // ... outros providers
  ],
  child: AdminDashboardPage(),
)
```

### Navegação
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
);
```

## Segurança

- Apenas usuários com role `admin` ou `super_admin` podem acessar
- Todas as ações são registradas em logs de auditoria
- Operações críticas requerem confirmação

## Performance

- Carregamento paralelo de métricas
- Paginação em listas grandes
- Cache de dados frequentes
- Debounce em buscas

## Próximas Melhorias

- [ ] Gráficos interativos com zoom
- [ ] Exportação de relatórios em PDF
- [ ] Notificações em tempo real
- [ ] Dashboard customizável
- [ ] Comparação de períodos
