import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/invitation_provider.dart';
import '../../domain/entities/invitation.dart';
import '../../../../core/theme/radiance_colors.dart';

class TeamInvitationsPage extends StatefulWidget {
  const TeamInvitationsPage({super.key});

  @override
  State<TeamInvitationsPage> createState() => _TeamInvitationsPageState();
}

class _TeamInvitationsPageState extends State<TeamInvitationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvitationProvider>().loadInvitations();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convites da Equipe'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendentes', icon: Icon(Icons.pending_outlined, size: 20)),
            Tab(text: 'Aceitos', icon: Icon(Icons.check_circle_outline, size: 20)),
            Tab(text: 'Histórico', icon: Icon(Icons.history, size: 20)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<InvitationProvider>().loadInvitations();
            },
          ),
        ],
      ),
      body: Consumer<InvitationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.invitations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildPendingTab(provider),
              _buildAcceptedTab(provider),
              _buildHistoryTab(provider),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showInviteDialog(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Convidar Membro'),
      ),
    );
  }

  Widget _buildPendingTab(InvitationProvider provider) {
    final invitations = provider.pendingInvitations;

    if (invitations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.mail_outline,
        message: 'Nenhum convite pendente',
        description: 'Convide membros para colaborar com sua equipe',
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadInvitations,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: invitations.length,
        itemBuilder: (context, index) {
          return _buildInvitationCard(invitations[index], provider);
        },
      ),
    );
  }

  Widget _buildAcceptedTab(InvitationProvider provider) {
    final invitations = provider.acceptedInvitations;

    if (invitations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        message: 'Nenhum convite aceito ainda',
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadInvitations,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: invitations.length,
        itemBuilder: (context, index) {
          return _buildAcceptedInvitationCard(invitations[index]);
        },
      ),
    );
  }

  Widget _buildHistoryTab(InvitationProvider provider) {
    final invitations = provider.expiredOrRejectedInvitations;

    if (invitations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        message: 'Histórico vazio',
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadInvitations,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: invitations.length,
        itemBuilder: (context, index) {
          return _buildHistoryCard(invitations[index], provider);
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    String? description,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInvitationCard(Invitation invitation, InvitationProvider provider) {
    final daysLeft = invitation.expiresAt.difference(DateTime.now()).inDays;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: RadianceColors.primary.withOpacity(0.1),
                  child: Text(
                    invitation.email[0].toUpperCase(),
                    style: const TextStyle(
                      color: RadianceColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invitation.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildRoleChip(invitation.role),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: daysLeft <= 2
                                  ? RadianceColors.error.withOpacity(0.1)
                                  : RadianceColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              daysLeft > 0
                                  ? 'Expira em $daysLeft ${daysLeft == 1 ? 'dia' : 'dias'}'
                                  : 'Expira hoje',
                              style: TextStyle(
                                fontSize: 11,
                                color: daysLeft <= 2
                                    ? RadianceColors.error
                                    : RadianceColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'copy':
                        _copyInviteLink(invitation.token);
                        break;
                      case 'resend':
                        _resendInvitation(invitation, provider);
                        break;
                      case 'cancel':
                        _cancelInvitation(invitation, provider);
                        break;
                      case 'delete':
                        _deleteInvitation(invitation, provider);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'copy',
                      child: Row(
                        children: [
                          Icon(Icons.copy, size: 20),
                          SizedBox(width: 12),
                          Text('Copiar Link'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'resend',
                      child: Row(
                        children: [
                          Icon(Icons.send, size: 20),
                          SizedBox(width: 12),
                          Text('Reenviar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'cancel',
                      child: Row(
                        children: [
                          Icon(Icons.cancel, size: 20),
                          SizedBox(width: 12),
                          Text('Cancelar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 12),
                          Text('Excluir', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Enviado em ${_formatDate(invitation.createdAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptedInvitationCard(Invitation invitation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: RadianceColors.success.withOpacity(0.1),
          child: const Icon(Icons.check, color: RadianceColors.success),
        ),
        title: Text(invitation.email),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            _buildRoleChip(invitation.role),
            const SizedBox(height: 4),
            Text(
              'Aceito em ${_formatDate(invitation.acceptedAt!)}',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildHistoryCard(Invitation invitation, InvitationProvider provider) {
    IconData icon;
    Color color;

    if (invitation.status == InvitationStatus.rejected) {
      icon = Icons.cancel;
      color = RadianceColors.error;
    } else if (invitation.isExpired) {
      icon = Icons.schedule;
      color = RadianceColors.warning;
    } else {
      icon = Icons.block;
      color = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(invitation.email),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                _buildRoleChip(invitation.role),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    invitation.statusDisplayWithExpiry,
                    style: TextStyle(fontSize: 10, color: color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Enviado em ${_formatDate(invitation.createdAt)}',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: invitation.canBeResent
            ? IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _resendInvitation(invitation, provider),
                tooltip: 'Reenviar',
              )
            : null,
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    Color color;
    switch (role.toLowerCase()) {
      case 'admin':
        color = RadianceColors.error;
        break;
      case 'manager':
        color = RadianceColors.warning;
        break;
      default:
        color = RadianceColors.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showInviteDialog(BuildContext context) {
    final emailController = TextEditingController();
    String selectedRole = 'member';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Convidar Novo Membro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'usuario@exemplo.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const Text(
                'Role',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                items: const [
                  DropdownMenuItem(value: 'member', child: Text('Member')),
                  DropdownMenuItem(value: 'manager', child: Text('Manager')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: (value) {
                  setState(() => selectedRole = value!);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Digite um email')),
                  );
                  return;
                }

                Navigator.of(ctx).pop();

                final provider = context.read<InvitationProvider>();
                final success = await provider.createInvitation(
                  email: email,
                  role: selectedRole,
                );

                if (context.mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Convite enviado para $email'),
                        backgroundColor: RadianceColors.success,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.error ?? 'Erro ao enviar convite'),
                        backgroundColor: RadianceColors.error,
                      ),
                    );
                  }
                }
              },
              child: const Text('Enviar Convite'),
            ),
          ],
        ),
      ),
    );
  }

  void _copyInviteLink(String token) {
    final link = 'https://radiance.app/invite/$token'; // URL mockada
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copiado para a área de transferência')),
    );
  }

  Future<void> _resendInvitation(
    Invitation invitation,
    InvitationProvider provider,
  ) async {
    final success = await provider.resendInvitation(invitation.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Convite reenviado com sucesso'
                : provider.error ?? 'Erro ao reenviar convite',
          ),
          backgroundColor: success ? RadianceColors.success : RadianceColors.error,
        ),
      );
    }
  }

  Future<void> _cancelInvitation(
    Invitation invitation,
    InvitationProvider provider,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar Convite'),
        content: Text('Deseja cancelar o convite para ${invitation.email}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sim, Cancelar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await provider.cancelInvitation(invitation.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Convite cancelado'
                  : provider.error ?? 'Erro ao cancelar convite',
            ),
            backgroundColor:
                success ? RadianceColors.success : RadianceColors.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteInvitation(
    Invitation invitation,
    InvitationProvider provider,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Convite'),
        content: Text(
          'Deseja excluir permanentemente o convite para ${invitation.email}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await provider.deleteInvitation(invitation.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Convite excluído'
                  : provider.error ?? 'Erro ao excluir convite',
            ),
            backgroundColor:
                success ? RadianceColors.success : RadianceColors.error,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
