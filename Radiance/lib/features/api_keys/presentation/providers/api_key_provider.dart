import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/api_key.dart';
import '../../data/repositories/api_key_repository.dart';
import '../../../multi_tenant/presentation/providers/tenant_provider.dart';
import '../../../../core/error/failures.dart';

/// Provider para gerenciar API Keys
class ApiKeyProvider extends ChangeNotifier {
  final ApiKeyRepository _repository;
  final TenantProvider _tenantProvider;

  List<ApiKey> _apiKeys = [];
  bool _isLoading = false;
  String? _error;
  String? _newlyCreatedKey; // Guarda a chave completa após criação

  ApiKeyProvider({
    required ApiKeyRepository repository,
    required TenantProvider tenantProvider,
  })  : _repository = repository,
        _tenantProvider = tenantProvider {
    _initialize();
  }

  // Getters
  List<ApiKey> get apiKeys => _apiKeys;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get newlyCreatedKey => _newlyCreatedKey;

  List<ApiKey> get activeKeys => _apiKeys.where((k) => k.canBeUsed).toList();
  List<ApiKey> get inactiveKeys => _apiKeys.where((k) => !k.canBeUsed).toList();
  
  int get activeKeysCount => activeKeys.length;

  Future<void> _initialize() async {
    if (_tenantProvider.currentCompany != null) {
      await loadApiKeys();
    }
  }

  /// Carrega todas as API Keys da empresa
  Future<void> loadApiKeys() async {
    final company = _tenantProvider.currentCompany;
    if (company == null) {
      _error = 'Nenhuma empresa selecionada';
      notifyListeners();
      return;
    }

    _setLoading(true);
    
    final result = await _repository.getCompanyApiKeys(company.id);
    
    result.fold(
      (failure) {
        _error = _getErrorMessage(failure);
        _apiKeys = [];
      },
      (keys) {
        _apiKeys = keys;
        _error = null;
      },
    );

    _setLoading(false);
  }

  /// Cria uma nova API Key
  Future<Either<Failure, String>> createApiKey({
    required String name,
    List<String>? permissions,
    DateTime? expiresAt,
  }) async {
    final company = _tenantProvider.currentCompany;
    if (company == null) {
      return const Left(ValidationFailure('Nenhuma empresa selecionada'));
    }

    // Verificar limites do plano
    if (!_tenantProvider.hasFeatureAccess('api_access')) {
      return const Left(SubscriptionFailure('Recurso disponível apenas no plano Enterprise'));
    }

    _setLoading(true);

    // Gerar a chave completa
    final fullKey = _repository.generateApiKey();
    
    final result = await _repository.createApiKey(
      companyId: company.id,
      name: name,
      permissions: permissions,
      expiresAt: expiresAt,
    );

    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (apiKey) {
        _newlyCreatedKey = fullKey; // Guardar chave completa
        _apiKeys.insert(0, apiKey);
        _error = null;
      },
    );

    _setLoading(false);

    return result.fold(
      (failure) => Left(failure),
      (_) => Right(fullKey),
    );
  }

  /// Atualiza uma API Key
  Future<Either<Failure, void>> updateApiKey({
    required String id,
    String? name,
    List<String>? permissions,
    DateTime? expiresAt,
  }) async {
    _setLoading(true);

    final result = await _repository.updateApiKey(
      id: id,
      name: name,
      permissions: permissions,
      expiresAt: expiresAt,
    );

    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (_) {
        final index = _apiKeys.indexWhere((k) => k.id == id);
        if (index != -1) {
          _apiKeys[index] = _apiKeys[index].copyWith(
            name: name,
            permissions: permissions,
            expiresAt: expiresAt,
            updatedAt: DateTime.now(),
          );
        }
        _error = null;
      },
    );

    _setLoading(false);

    return result;
  }

  /// Revoga uma API Key
  Future<Either<Failure, void>> revokeApiKey(String id) async {
    _setLoading(true);

    final result = await _repository.revokeApiKey(id);

    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (_) {
        final index = _apiKeys.indexWhere((k) => k.id == id);
        if (index != -1) {
          _apiKeys[index] = _apiKeys[index].copyWith(
            isActive: false,
            updatedAt: DateTime.now(),
          );
        }
        _error = null;
      },
    );

    _setLoading(false);

    return result;
  }

  /// Deleta uma API Key
  Future<Either<Failure, void>> deleteApiKey(String id) async {
    _setLoading(true);

    final result = await _repository.deleteApiKey(id);

    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (_) {
        _apiKeys.removeWhere((k) => k.id == id);
        _error = null;
      },
    );

    _setLoading(false);

    return result;
  }

  /// Limpa a chave recém-criada (após ser copiada)
  void clearNewlyCreatedKey() {
    _newlyCreatedKey = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _getErrorMessage(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    if (failure is NetworkFailure) return 'Erro de conexão';
    if (failure is ValidationFailure) return failure.message;
    if (failure is NotFoundFailure) return failure.message;
    if (failure is UnauthorizedFailure) return 'Não autorizado';
    if (failure is SubscriptionFailure) return failure.message;
    return 'Erro desconhecido';
  }
}
