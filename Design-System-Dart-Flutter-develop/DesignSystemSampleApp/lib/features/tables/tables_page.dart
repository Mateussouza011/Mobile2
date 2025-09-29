import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';

<<<<<<< HEAD
/// Página que demonstra tabelas com design Shadcn/UI
=======
/// Página que demonstra tabelas com tema adaptativo
>>>>>>> baaf4e60e678a42cfff006835c1a6a8e64dc3ea9
class TablesPage extends StatelessWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
=======
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
>>>>>>> baaf4e60e678a42cfff006835c1a6a8e64dc3ea9
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tabelas',
<<<<<<< HEAD
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
=======
          style: theme.textTheme.titleLarge,
>>>>>>> baaf4e60e678a42cfff006835c1a6a8e64dc3ea9
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
<<<<<<< HEAD
              'Demonstração de Tabelas',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
=======
              'Tabela com dados e ações, adaptada para light e dark theme.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
>>>>>>> baaf4e60e678a42cfff006835c1a6a8e64dc3ea9
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tabela com 3 colunas (Nome, Status, Ação) e contraste adequado em ambos os temas.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            
<<<<<<< HEAD
            Card(
              color: colorScheme.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tabela de Usuários',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingTextStyle: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        dataTextStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        columns: const [
                          DataColumn(label: Text('Nome')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Ação')),
                        ],
                        rows: [
                          _buildDataRow('João Silva', 'Ativo', colorScheme, context),
                          _buildDataRow('Maria Santos', 'Inativo', colorScheme, context),
                          _buildDataRow('Pedro Oliveira', 'Ativo', colorScheme, context),
                          _buildDataRow('Ana Costa', 'Pendente', colorScheme, context),
                          _buildDataRow('Carlos Lima', 'Ativo', colorScheme, context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
=======
            _buildDataTable(context),
>>>>>>> baaf4e60e678a42cfff006835c1a6a8e64dc3ea9
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  DataRow _buildDataRow(String nome, String status, ColorScheme colorScheme, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            nome,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(status, colorScheme),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getStatusTextColor(status, colorScheme),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ver mais: $nome'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(80, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text('Ver mais'),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'Ativo':
        return colorScheme.primary.withOpacity(0.1);
      case 'Inativo':
        return colorScheme.error.withOpacity(0.1);
      case 'Pendente':
        return colorScheme.secondary.withOpacity(0.1);
      default:
        return colorScheme.surfaceVariant;
    }
  }

  Color _getStatusTextColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'Ativo':
        return colorScheme.primary;
      case 'Inativo':
        return colorScheme.error;
      case 'Pendente':
        return colorScheme.secondary;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }
}
=======
  Widget _buildDataTable(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Dados fake para a tabela
    final data = [
      {'nome': 'João Silva', 'status': 'Ativo', 'id': 1},
      {'nome': 'Maria Santos', 'status': 'Inativo', 'id': 2},
      {'nome': 'Pedro Costa', 'status': 'Ativo', 'id': 3},
      {'nome': 'Ana Oliveira', 'status': 'Pendente', 'id': 4},
      {'nome': 'Carlos Ferreira', 'status': 'Ativo', 'id': 5},
    ];

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lista de Usuários',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            
            // Cabeçalho da tabela
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Nome',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Status',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Ação',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            
            // Linhas da tabela
            ...data.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == data.length - 1;
              
              return Container(
                decoration: BoxDecoration(
                  color: index.isEven 
                    ? colorScheme.surface
                    : colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: isLast ? const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ) : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      // Nome
                      Expanded(
                        flex: 3,
                        child: Text(
                          item['nome'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      
                      // Status
                      Expanded(
                        flex: 2,
                        child: _buildStatusChip(context, item['status'] as String),
                      ),
                      
                      // Ação
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: SizedBox(
                            width: 100,
                            height: 32,
                            child: ShadcnButton(
                              text: 'Ver mais',
                              variant: ShadcnButtonVariant.outline,
                              size: ShadcnButtonSize.sm,
                              onPressed: () => _showUserDetails(context, item),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    Color backgroundColor;
    Color textColor;
    
    switch (status.toLowerCase()) {
      case 'ativo':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green.shade700;
        break;
      case 'inativo':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red.shade700;
        break;
      case 'pendente':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange.shade700;
        break;
      default:
        backgroundColor = colorScheme.surfaceVariant;
        textColor = colorScheme.onSurfaceVariant;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showUserDetails(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalhes do Usuário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${user['nome']}'),
              const SizedBox(height: 8),
              Text('Status: ${user['status']}'),
              const SizedBox(height: 8),
              Text('ID: ${user['id']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
>>>>>>> baaf4e60e678a42cfff006835c1a6a8e64dc3ea9
