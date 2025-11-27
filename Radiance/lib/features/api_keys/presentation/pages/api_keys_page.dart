import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/api_key.dart';
import '../providers/api_key_provider.dart';
import '../../../multi_tenant/presentation/providers/tenant_provider.dart';
import '../../../../core/theme/radiance_colors.dart';

class ApiKeysPage extends StatefulWidget {
  const ApiKeysPage({super.key});

  @override
  State<ApiKeysPage> createState() => _ApiKeysPageState();
}

class _ApiKeysPageState extends State<ApiKeysPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApiKeyProvider>().loadApiKeys();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tenantProvider = context.watch<TenantProvider>();
    final hasApiAccess = tenantProvider.hasFeatureAccess('api_access');

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Keys'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showDocumentation,
          ),
        ],
      ),
      body: !hasApiAccess
          ? _buildUpgradePrompt()
          : Consumer<ApiKeyProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.apiKeys.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return RefreshIndicator(
                  onRefresh: provider.loadApiKeys,
                  child: provider.apiKeys.isEmpty
                      ? _buildEmptyState()
                      : _buildKeysList(provider),
                );
              },
            ),
      floatingActionButton: hasApiAccess
          ? FloatingActionButton.extended(
              onPressed: _showCreateKeyDialog,
              icon: const Icon(Icons.add),
              label: const Text('Nova API Key'),
            )
          : null,
    );
  }

  Widget _buildUpgradePrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.api,
              size: 80,
              color: RadianceColors.warning,
            ),
            const SizedBox(height: 24),
            Text(
              'Recurso Enterprise',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'O acesso à API está disponível apenas no plano Enterprise.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navegar para página de planos
              },
              icon: const Icon(Icons.upgrade),
              label: const Text('Fazer Upgrade'),
              style: ElevatedButton.styleFrom(
                backgroundColor: RadianceColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.key_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma API Key cadastrada',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showCreateKeyDialog,
            icon: const Icon(Icons.add),
            label: const Text('Criar Primeira Key'),
          ),
        ],
      ),
    );
  }

  Widget _buildKeysList(ApiKeyProvider provider) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildStatsCard(provider),
          ),
        ),
        if (provider.activeKeys.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Ativas (${provider.activeKeys.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final key = provider.activeKeys[index];
                return _buildKeyCard(context, key, provider);
              },
              childCount: provider.activeKeys.length,
            ),
          ),
        ],
        if (provider.inactiveKeys.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Inativas (${provider.inactiveKeys.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final key = provider.inactiveKeys[index];
                return _buildKeyCard(context, key, provider);
              },
              childCount: provider.inactiveKeys.length,
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildStatsCard(ApiKeyProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'Total',
                provider.apiKeys.length.toString(),
                Icons.key,
                RadianceColors.primary,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey[300],
            ),
            Expanded(
              child: _buildStatItem(
                'Ativas',
                provider.activeKeysCount.toString(),
                Icons.check_circle,
                RadianceColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyCard(BuildContext context, ApiKey key, ApiKeyProvider provider) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: key.canBeUsed
              ? RadianceColors.success.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          child: Icon(
            Icons.vpn_key,
            color: key.canBeUsed ? RadianceColors.success : Colors.grey,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                key.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (!key.isActive)
              Chip(
                label: const Text('Revogada', style: TextStyle(fontSize: 10)),
                backgroundColor: RadianceColors.error,
                labelStyle: const TextStyle(color: Colors.white),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            if (key.isExpired)
              Chip(
                label: const Text('Expirada', style: TextStyle(fontSize: 10)),
                backgroundColor: RadianceColors.warning,
                labelStyle: const TextStyle(color: Colors.white),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  key.displayKey,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _copyToClipboard(key.prefix),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Criada: ${_formatDate(key.createdAt)}',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
            if (key.lastUsedAt != null)
              Text(
                'Último uso: ${_formatDate(key.lastUsedAt!)}',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            if (key.permissions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: key.permissions.take(3).map((p) {
                  return Chip(
                    label: Text(
                      ApiKeyPermission.getDisplayName(p),
                      style: const TextStyle(fontSize: 10),
                    ),
                    backgroundColor: RadianceColors.info.withOpacity(0.1),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(context, value, key, provider),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            if (key.isActive)
              const PopupMenuItem(
                value: 'revoke',
                child: Row(
                  children: [
                    Icon(Icons.block, size: 20, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Revogar', style: TextStyle(color: Colors.orange)),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Deletar', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    String action,
    ApiKey key,
    ApiKeyProvider provider,
  ) {
    switch (action) {
      case 'edit':
        _showEditKeyDialog(key);
        break;
      case 'revoke':
        _confirmRevokeKey(context, key, provider);
        break;
      case 'delete':
        _confirmDeleteKey(context, key, provider);
        break;
    }
  }

  void _showCreateKeyDialog() {
    showDialog(
      context: context,
      builder: (context) => const _CreateApiKeyDialog(),
    );
  }

  void _showEditKeyDialog(ApiKey key) {
    showDialog(
      context: context,
      builder: (context) => _EditApiKeyDialog(apiKey: key),
    );
  }

  void _confirmRevokeKey(BuildContext context, ApiKey key, ApiKeyProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revogar API Key'),
        content: Text('Deseja realmente revogar a chave "${key.name}"? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              Navigator.pop(context);
              final result = await provider.revokeApiKey(key.id);
              
              if (!context.mounted) return;
              
              result.fold(
                (failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro: ${failure.toString()}'),
                      backgroundColor: RadianceColors.error,
                    ),
                  );
                },
                (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('API Key revogada com sucesso'),
                      backgroundColor: RadianceColors.success,
                    ),
                  );
                },
              );
            },
            child: const Text('Revogar'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteKey(BuildContext context, ApiKey key, ApiKeyProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar API Key'),
        content: Text('Deseja realmente deletar a chave "${key.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: RadianceColors.error),
            onPressed: () async {
              Navigator.pop(context);
              final result = await provider.deleteApiKey(key.id);
              
              if (!context.mounted) return;
              
              result.fold(
                (failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro: ${failure.toString()}'),
                      backgroundColor: RadianceColors.error,
                    ),
                  );
                },
                (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('API Key deletada com sucesso'),
                      backgroundColor: RadianceColors.success,
                    ),
                  );
                },
              );
            },
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copiado para área de transferência'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDocumentation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Documentação da API'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Endpoints Disponíveis:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('GET /api/v1/predictions'),
              Text('POST /api/v1/predictions'),
              Text('GET /api/v1/company'),
              SizedBox(height: 16),
              Text(
                'Autenticação:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Header: Authorization: Bearer {your_api_key}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _CreateApiKeyDialog extends StatefulWidget {
  const _CreateApiKeyDialog();

  @override
  State<_CreateApiKeyDialog> createState() => _CreateApiKeyDialogState();
}

class _CreateApiKeyDialogState extends State<_CreateApiKeyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _selectedPermissions = <String>{};
  DateTime? _expiresAt;
  bool _isCreating = false;
  String? _createdKey;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_createdKey != null) {
      return _buildSuccessDialog();
    }

    return AlertDialog(
      title: const Text('Nova API Key'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  hintText: 'Ex: Produção, Desenvolvimento',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite um nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Permissões:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              ...ApiKeyPermission.all.map((permission) {
                return CheckboxListTile(
                  title: Text(ApiKeyPermission.getDisplayName(permission)),
                  subtitle: Text(
                    ApiKeyPermission.getDescription(permission),
                    style: const TextStyle(fontSize: 11),
                  ),
                  value: _selectedPermissions.contains(permission),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedPermissions.add(permission);
                      } else {
                        _selectedPermissions.remove(permission);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                );
              }),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _expiresAt != null,
                    onChanged: (value) async {
                      if (value == true) {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 90)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() => _expiresAt = date);
                        }
                      } else {
                        setState(() => _expiresAt = null);
                      }
                    },
                  ),
                  Expanded(
                    child: Text(
                      _expiresAt == null
                          ? 'Sem expiração'
                          : 'Expira em: ${_formatDate(_expiresAt!)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCreating ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _handleCreate,
          child: _isCreating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Criar'),
        ),
      ],
    );
  }

  Widget _buildSuccessDialog() {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.check_circle, color: RadianceColors.success),
          const SizedBox(width: 8),
          const Text('API Key Criada!'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sua API key foi criada com sucesso. Copie-a agora, pois ela não será exibida novamente.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: SelectableText(
              _createdKey!,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: _createdKey!));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('API Key copiada!'),
                backgroundColor: RadianceColors.success,
              ),
            );
          },
          child: const Text('Copiar e Fechar'),
        ),
      ],
    );
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreating = true);

    final provider = context.read<ApiKeyProvider>();
    final result = await provider.createApiKey(
      name: _nameController.text,
      permissions: _selectedPermissions.toList(),
      expiresAt: _expiresAt,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${failure.toString()}'),
            backgroundColor: RadianceColors.error,
          ),
        );
      },
      (apiKey) {
        setState(() {
          _createdKey = apiKey;
          _isCreating = false;
        });
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _EditApiKeyDialog extends StatefulWidget {
  final ApiKey apiKey;

  const _EditApiKeyDialog({required this.apiKey});

  @override
  State<_EditApiKeyDialog> createState() => _EditApiKeyDialogState();
}

class _EditApiKeyDialogState extends State<_EditApiKeyDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final Set<String> _selectedPermissions;
  late DateTime? _expiresAt;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.apiKey.name);
    _selectedPermissions = Set.from(widget.apiKey.permissions);
    _expiresAt = widget.apiKey.expiresAt;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar API Key'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite um nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Permissões:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              ...ApiKeyPermission.all.map((permission) {
                return CheckboxListTile(
                  title: Text(ApiKeyPermission.getDisplayName(permission)),
                  value: _selectedPermissions.contains(permission),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedPermissions.add(permission);
                      } else {
                        _selectedPermissions.remove(permission);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isUpdating ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isUpdating ? null : _handleUpdate,
          child: _isUpdating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Salvar'),
        ),
      ],
    );
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUpdating = true);

    final provider = context.read<ApiKeyProvider>();
    final result = await provider.updateApiKey(
      id: widget.apiKey.id,
      name: _nameController.text,
      permissions: _selectedPermissions.toList(),
      expiresAt: _expiresAt,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${failure.toString()}'),
            backgroundColor: RadianceColors.error,
          ),
        );
      },
      (_) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('API Key atualizada com sucesso'),
            backgroundColor: RadianceColors.success,
          ),
        );
      },
    );
  }
}
