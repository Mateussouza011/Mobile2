import 'package:flutter/foundation.dart';
import '../../domain/entities/invitation.dart';
import '../../data/repositories/invitation_repository.dart';
import '../../../multi_tenant/presentation/providers/tenant_provider.dart';
import '../../../../core/error/failures.dart';

/// Provider para gerenciar convites de equipe
class InvitationProvider extends ChangeNotifier {
  final InvitationRepository _repository;
  final TenantProvider _tenantProvider;

  List<Invitation> _invitations = [];
  bool _isLoading = false;
  String? _error;

  InvitationProvider({
    required InvitationRepository repository,
    required TenantProvider tenantProvider,
  })  : _repository = repository,
        _tenantProvider = tenantProvider {
    _initialize();
  }

  // Getters
  List<Invitation> get invitations => _invitations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Invitation> get pendingInvitations =>
      _invitations.where((i) => i.isPending).toList();

  List<Invitation> get acceptedInvitations =>
      _invitations.where((i) => i.status == InvitationStatus.accepted).toList();

  List<Invitation> get expiredOrRejectedInvitations =>
      _invitations.where((i) => 
        i.status == InvitationStatus.rejected ||
        i.status == InvitationStatus.expired ||
        (i.status == InvitationStatus.pending && i.isExpired)
      ).toList();

  Future<void> _initialize() async {
    if (_tenantProvider.currentCompany != null) {
      await loadInvitations();
    }
  }

  /// Carrega convites da empresa
  Future<void> loadInvitations() async {
    final company = _tenantProvider.currentCompany;
    if (company == null) {
      _error = 'Nenhuma empresa selecionada';
      notifyListeners();
      return;
    }

    _setLoading(true);

    final result = await _repository.getCompanyInvitations(company.id);

    result.fold(
      (failure) {
        _error = _getErrorMessage(failure);
        _invitations = [];
      },
      (invitations) {
        _invitations = invitations;
        _error = null;
      },
    );

    _setLoading(false);
  }

  /// Cria novo convite
  Future<bool> createInvitation({
    required String email,
    required String role,
    int validityDays = 7,
  }) async {
    final company = _tenantProvider.currentCompany;

    if (company == null) {
      _error = 'Erro: empresa não identificada';
      notifyListeners();
      return false;
    }

    // Validar email
    if (!_isValidEmail(email)) {
      _error = 'Email inválido';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    final result = await _repository.createInvitation(
      companyId: company.id,
      email: email.trim().toLowerCase(),
      role: role,
      invitedBy: '1', // TODO: Get from auth context
      validityDays: validityDays,
    );

    bool success = false;
    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (invitation) {
        _invitations.insert(0, invitation);
        _error = null;
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  /// Cancela um convite
  Future<bool> cancelInvitation(String invitationId) async {
    _setLoading(true);

    final result = await _repository.cancelInvitation(invitationId);

    bool success = false;
    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (_) {
        final index = _invitations.indexWhere((i) => i.id == invitationId);
        if (index != -1) {
          _invitations[index] = _invitations[index].copyWith(
            status: InvitationStatus.cancelled,
          );
        }
        _error = null;
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  /// Reenvia um convite
  Future<bool> resendInvitation(String invitationId) async {
    _setLoading(true);

    final result = await _repository.resendInvitation(invitationId);

    bool success = false;
    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (updatedInvitation) {
        final index = _invitations.indexWhere((i) => i.id == invitationId);
        if (index != -1) {
          _invitations[index] = updatedInvitation;
        }
        _error = null;
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  /// Exclui um convite
  Future<bool> deleteInvitation(String invitationId) async {
    _setLoading(true);

    final result = await _repository.deleteInvitation(invitationId);

    bool success = false;
    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (_) {
        _invitations.removeWhere((i) => i.id == invitationId);
        _error = null;
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  String _getErrorMessage(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    if (failure is NetworkFailure) return 'Erro de conexão';
    if (failure is DatabaseFailure) return failure.message;
    return 'Erro desconhecido';
  }
}
