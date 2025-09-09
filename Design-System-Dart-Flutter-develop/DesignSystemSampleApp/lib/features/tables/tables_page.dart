import 'package:flutter/material.dart';

/// Página que demonstra diferentes tipos de tabelas
class TablesPage extends StatelessWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tabelas',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DataTables e grids para exibição de dados',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tabela Simples',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              'Nome',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Email',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('João Silva', style: Theme.of(context).textTheme.bodyMedium)),
                            DataCell(Text('joao@email.com', style: Theme.of(context).textTheme.bodyMedium)),
                            DataCell(Text('Ativo', style: Theme.of(context).textTheme.bodyMedium)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Maria Santos', style: Theme.of(context).textTheme.bodyMedium)),
                            DataCell(Text('maria@email.com', style: Theme.of(context).textTheme.bodyMedium)),
                            DataCell(Text('Inativo', style: Theme.of(context).textTheme.bodyMedium)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Pedro Costa', style: Theme.of(context).textTheme.bodyMedium)),
                            DataCell(Text('pedro@email.com', style: Theme.of(context).textTheme.bodyMedium)),
                            DataCell(Text('Ativo', style: Theme.of(context).textTheme.bodyMedium)),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
