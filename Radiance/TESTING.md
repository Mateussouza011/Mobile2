# Guia de Testes - Radiance B2B Professional

## Visão Geral

Este documento descreve a suíte de testes do módulo Admin Panel do Radiance B2B Professional.

## Estrutura de Testes

```
test/
├── domain/
│   └── repositories/
│       └── admin/
│           ├── admin_audit_repository_test.dart    # 41 testes
│           ├── admin_company_repository_test.dart  # 23 testes
│           ├── admin_metrics_repository_test.dart  # 26 testes
│           ├── admin_subscription_repository_test.dart # 21 testes
│           └── admin_user_repository_test.dart     # 22 testes
├── presentation/
│   └── providers/
│       ├── admin_company_provider_test.dart        # 27 testes
│       ├── admin_user_provider_test.dart           # 31 testes
│       ├── admin_audit_provider_test.dart          # 29 testes
│       ├── admin_subscription_provider_test.dart   # 36 testes
│       └── admin_metrics_provider_test.dart        # 52 testes
└── helpers/
    └── test_helpers.dart                           # Utilitários de teste
```

## Total de Testes: 333+

### Testes de Repositório (133 testes)

Os testes de repositório verificam a camada de dados e suas interações com o banco SQLite.

#### AdminCompanyRepository (23 testes)
- Listagem de empresas com filtros
- Detalhes da empresa
- Estatísticas do sistema
- Ativação/desativação de empresas
- Atualização de dados
- Ordenação e paginação

#### AdminUserRepository (22 testes)
- Listagem de usuários com filtros
- Detalhes do usuário
- Alteração de roles
- Ativação/desativação
- Logs de atividade
- Transferência entre empresas

#### AdminSubscriptionRepository (21 testes)
- Listagem de assinaturas
- Upgrade/downgrade de tier
- Cancelamento e reativação
- Suspensão
- Processamento de reembolso
- Estatísticas do sistema

#### AdminMetricsRepository (26 testes)
- Métricas do sistema
- Métricas de receita
- Métricas de crescimento de usuários
- Distribuição por tier
- Métricas de uso
- Métricas de saúde do sistema

#### AdminAuditRepository (41 testes)
- Criação de logs de auditoria
- Listagem com filtros avançados
- Paginação de logs
- Estatísticas de auditoria
- Exportação para CSV
- Filtragem por tipo de entidade, ação, data

### Testes de Provider (175 testes)

Os testes de provider verificam o gerenciamento de estado e lógica de negócios.

#### AdminCompanyProvider (27 testes)
- Estado inicial
- Carregamento de empresas
- Busca e filtros
- CRUD de empresas
- Propriedades computadas
- Notificação de listeners

#### AdminUserProvider (31 testes)
- Estado inicial
- Carregamento de usuários
- Busca por nome/email
- Alteração de roles
- Ativação/desativação
- Estatísticas do sistema

#### AdminAuditProvider (29 testes)
- Estado inicial
- Carregamento de logs
- Filtros avançados
- Paginação infinita
- Estatísticas
- Exportação CSV

#### AdminSubscriptionProvider (36 testes)
- Estado inicial
- Carregamento de assinaturas
- Filtros por tier/status
- Upgrade/downgrade
- Cancelamento/reativação
- Cálculos de MRR e receita

#### AdminMetricsProvider (52 testes)
- Estado inicial
- Carregamento de todas as métricas
- Carregamento individual de métricas
- Propriedades computadas
- Refresh e clear
- Tratamento de erros

## Executando os Testes

### Todos os testes
```bash
flutter test
```

### Testes de repositório
```bash
flutter test test/domain/repositories/admin/
```

### Testes de provider
```bash
flutter test test/presentation/providers/
```

### Teste específico
```bash
flutter test test/domain/repositories/admin/admin_audit_repository_test.dart
```

### Com cobertura
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Configuração de Teste

### Banco de Dados In-Memory

Os testes usam `sqflite_common_ffi` para criar bancos de dados SQLite em memória:

```dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

setUpAll(() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
});
```

### Helpers de Teste

O arquivo `test/helpers/test_helpers.dart` fornece:
- Criação de banco de dados de teste
- Dados de seed para testes
- Funções utilitárias

### Mocking

Os testes usam Mockito para criar mocks:

```dart
@GenerateMocks([AdminCompanyRepository])
import 'admin_company_provider_test.mocks.dart';
```

Para regenerar os mocks:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Padrões de Teste

### Estrutura AAA (Arrange-Act-Assert)
```dart
test('should load companies successfully', () async {
  // Arrange
  when(mockRepository.getAllCompanies(any))
      .thenAnswer((_) async => Right(testCompanies));
  
  // Act
  await provider.loadCompanies();
  
  // Assert
  expect(provider.companies, equals(testCompanies));
  expect(provider.isLoading, false);
  verify(mockRepository.getAllCompanies(any)).called(1);
});
```

### Grupos de Teste
```dart
group('AdminCompanyProvider', () {
  group('Initial State', () {
    // Testes de estado inicial
  });
  
  group('loadCompanies', () {
    // Testes de carregamento
  });
  
  group('CRUD Operations', () {
    // Testes CRUD
  });
});
```

## Cobertura de Código

### Métricas Alvo
- Linhas: > 80%
- Branches: > 75%
- Funções: > 85%

### Relatório de Cobertura
```bash
flutter test --coverage
# Gera coverage/lcov.info
```

## Troubleshooting

### Testes Flaky
- Verifique dependências de estado
- Use `setUpAll` e `tearDownAll` apropriadamente
- Evite dependências de tempo real

### Erros de Mock
- Regenere os mocks com `build_runner`
- Verifique imports de anotações
- Confirme que os métodos mockados existem

### Erros de Banco
- Confirme que `sqfliteFfiInit()` é chamado
- Verifique esquema do banco de teste
- Use bancos in-memory para isolamento

## Contribuindo

1. Escreva testes para novas funcionalidades
2. Mantenha cobertura acima de 80%
3. Siga padrões AAA
4. Use grupos para organização
5. Documente casos de edge

## Próximos Passos

- [ ] Testes de widget para páginas admin
- [ ] Testes de integração E2E
- [ ] Testes de performance
- [ ] Testes de snapshot para UI
