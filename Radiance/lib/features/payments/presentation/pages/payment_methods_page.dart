import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/subscription_data.dart';
import '../providers/payment_provider.dart';
import '../../../../core/theme/radiance_colors.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PaymentProvider>();
      provider.loadPaymentMethods();
      provider.loadPaymentHistory();
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
        title: const Text('Pagamentos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Métodos de Pagamento'),
            Tab(text: 'Histórico'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPaymentMethodsTab(),
          _buildPaymentHistoryTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddPaymentMethodDialog,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Cartão'),
            )
          : null,
    );
  }

  Widget _buildPaymentMethodsTab() {
    return Consumer<PaymentProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: RadianceColors.error),
                const SizedBox(height: 16),
                Text(
                  provider.error!,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadPaymentMethods(),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        final methods = provider.paymentMethods;

        if (methods.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.credit_card_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum método de pagamento cadastrado',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showAddPaymentMethodDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar Cartão'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: methods.length,
          itemBuilder: (context, index) {
            final method = methods[index];
            return _buildPaymentMethodCard(context, method, provider);
          },
        );
      },
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    PaymentMethod method,
    PaymentProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: RadianceColors.primary.withOpacity(0.1),
          child: Icon(
            _getCardIcon(method.type),
            color: RadianceColors.primary,
          ),
        ),
        title: Row(
          children: [
            Text(
              _getCardBrandDisplay(method.cardBrand),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (method.isDefault)
              const Chip(
                label: Text(
                  'Padrão',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
                backgroundColor: RadianceColors.success,
                padding: EdgeInsets.symmetric(horizontal: 4),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('•••• •••• •••• ${method.cardLast4 ?? "****"}'),
            if (method.cardExpMonth != null && method.cardExpYear != null)
              Text(
                'Validade: ${method.cardExpMonth}/${method.cardExpYear}',
                style: TextStyle(
                  fontSize: 12,
                  color: method.isExpired 
                      ? RadianceColors.error 
                      : Colors.grey[600],
                ),
              ),
            if (method.isExpired)
              const Text(
                'Cartão expirado',
                style: TextStyle(
                  fontSize: 12,
                  color: RadianceColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'remove') {
              _confirmRemovePaymentMethod(context, method, provider);
            }
          },
          itemBuilder: (context) => [
            if (!method.isDefault)
              const PopupMenuItem(
                value: 'default',
                child: Row(
                  children: [
                    Icon(Icons.star, size: 20),
                    SizedBox(width: 8),
                    Text('Definir como padrão'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'remove',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Remover', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryTab() {
    return Consumer<PaymentProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final history = provider.paymentHistory;

        if (history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum pagamento registrado',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final payment = history[index];
            return _buildPaymentHistoryCard(payment);
          },
        );
      },
    );
  }

  Widget _buildPaymentHistoryCard(PaymentHistory payment) {
    final isPaid = payment.status == 'paid';
    final isFailed = payment.status == 'failed';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isPaid
              ? RadianceColors.success.withOpacity(0.1)
              : isFailed
                  ? RadianceColors.error.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
          child: Icon(
            isPaid ? Icons.check_circle : isFailed ? Icons.error : Icons.schedule,
            color: isPaid
                ? RadianceColors.success
                : isFailed
                    ? RadianceColors.error
                    : Colors.grey,
          ),
        ),
        title: Text(
          'R\$ ${payment.amount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(_formatDate(payment.createdAt)),
            if (payment.paymentMethod != null)
              Text(
                payment.paymentMethod!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            const SizedBox(height: 4),
            _buildPaymentStatusChip(payment.status),
          ],
        ),
        trailing: payment.transactionId != null
            ? IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showPaymentDetails(payment),
              )
            : null,
      ),
    );
  }

  Widget _buildPaymentStatusChip(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'paid':
        color = RadianceColors.success;
        label = 'Pago';
        break;
      case 'failed':
        color = RadianceColors.error;
        label = 'Falhou';
        break;
      case 'pending':
        color = RadianceColors.warning;
        label = 'Pendente';
        break;
      case 'refunded':
        color = RadianceColors.info;
        label = 'Reembolsado';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showAddPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => const _AddPaymentMethodDialog(),
    );
  }

  void _confirmRemovePaymentMethod(
    BuildContext context,
    PaymentMethod method,
    PaymentProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Cartão'),
        content: Text(
          'Deseja realmente remover o cartão ${_getCardBrandDisplay(method.cardBrand)} •••• ${method.cardLast4}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: RadianceColors.error,
            ),
            onPressed: () async {
              Navigator.pop(context);
              final result = await provider.removePaymentMethod(method.id);
              
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
                    const SnackBar(
                      content: Text('Cartão removido com sucesso'),
                      backgroundColor: RadianceColors.success,
                    ),
                  );
                },
              );
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  void _showPaymentDetails(PaymentHistory payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalhes do Pagamento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Valor', 'R\$ ${payment.amount.toStringAsFixed(2)}'),
            _buildDetailRow('Status', payment.status),
            _buildDetailRow('Data', _formatDate(payment.createdAt)),
            if (payment.paidAt != null)
              _buildDetailRow('Pago em', _formatDate(payment.paidAt!)),
            if (payment.paymentMethod != null)
              _buildDetailRow('Método', payment.paymentMethod!),
            if (payment.transactionId != null)
              _buildDetailRow('ID Transação', payment.transactionId!),
          ],
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  IconData _getCardIcon(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        return Icons.credit_card;
      case PaymentMethodType.pix:
        return Icons.pix;
      case PaymentMethodType.boleto:
        return Icons.receipt;
    }
  }

  String _getCardBrandDisplay(String? brand) {
    if (brand == null) return 'Cartão';
    
    switch (brand.toLowerCase()) {
      case 'visa':
        return 'Visa';
      case 'mastercard':
        return 'Mastercard';
      case 'amex':
        return 'American Express';
      case 'elo':
        return 'Elo';
      case 'hipercard':
        return 'Hipercard';
      default:
        return brand;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _AddPaymentMethodDialog extends StatefulWidget {
  const _AddPaymentMethodDialog();

  @override
  State<_AddPaymentMethodDialog> createState() => _AddPaymentMethodDialogState();
}

class _AddPaymentMethodDialogState extends State<_AddPaymentMethodDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _setAsDefault = false;
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Cartão'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número do Cartão',
                  hintText: '0000 0000 0000 0000',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                maxLength: 19,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o número do cartão';
                  }
                  final cleaned = value.replaceAll(' ', '');
                  if (cleaned.length < 13) {
                    return 'Número do cartão inválido';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Formatar cartão automaticamente
                  final text = value.replaceAll(' ', '');
                  if (text.length <= 16) {
                    final formatted = _formatCardNumber(text);
                    if (formatted != value) {
                      _cardNumberController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(
                          offset: formatted.length,
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardHolderController,
                decoration: const InputDecoration(
                  labelText: 'Nome no Cartão',
                  hintText: 'NOME COMPLETO',
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o nome no cartão';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: const InputDecoration(
                        labelText: 'Validade',
                        hintText: 'MM/AA',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite a validade';
                        }
                        if (!value.contains('/') || value.length != 5) {
                          return 'Formato inválido';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.length == 2 && !value.contains('/')) {
                          _expiryController.text = '$value/';
                          _expiryController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _expiryController.text.length),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite o CVV';
                        }
                        if (value.length < 3) {
                          return 'CVV inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Definir como padrão'),
                value: _setAsDefault,
                onChanged: (value) {
                  setState(() => _setAsDefault = value ?? false);
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isProcessing ? null : _handleAddCard,
          child: _isProcessing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Adicionar'),
        ),
      ],
    );
  }

  String _formatCardNumber(String value) {
    final buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      buffer.write(value[i]);
      final nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != value.length) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  Future<void> _handleAddCard() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // TODO: Integrar com tokenização real do Abacate Pay
    // Por enquanto, simular token
    final token = 'tok_${DateTime.now().millisecondsSinceEpoch}';

    final provider = context.read<PaymentProvider>();
    final result = await provider.addPaymentMethod(
      token: token,
      setAsDefault: _setAsDefault,
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
      (method) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cartão adicionado com sucesso!'),
            backgroundColor: RadianceColors.success,
          ),
        );
      },
    );
  }
}
