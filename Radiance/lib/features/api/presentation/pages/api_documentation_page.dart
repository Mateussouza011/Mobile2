import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/radiance_colors.dart';

/// Página de documentação da API REST
class ApiDocumentationPage extends StatelessWidget {
  const ApiDocumentationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Documentation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.link),
            onPressed: () {
              // TODO: Abrir URL da documentação online
            },
            tooltip: 'View Online',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildAuthSection(context),
          const SizedBox(height: 24),
          _buildRateLimitsSection(context),
          const SizedBox(height: 24),
          _buildEndpointsSection(context),
          const SizedBox(height: 24),
          _buildErrorCodesSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.api, size: 32, color: RadianceColors.primary),
                const SizedBox(width: 12),
                Text(
                  'Radiance REST API v1',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'API RESTful para integração com a plataforma Radiance de previsão de preços de diamantes.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SelectableText(
                'Base URL: https://api.radiance.app/v1',
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Autenticação',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Todas as requisições devem incluir uma API Key válida no header Authorization:',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            _buildCodeBlock('Authorization: Bearer rdk_your_api_key_here'),
            const SizedBox(height: 12),
            Chip(
              label: const Text('Enterprise Only', style: TextStyle(fontSize: 12)),
              backgroundColor: RadianceColors.warning.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateLimitsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate Limits',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildRateLimitRow('Free', '10/min', '100/hour'),
            _buildRateLimitRow('Pro', '60/min', '1,000/hour'),
            _buildRateLimitRow('Enterprise', '300/min', '10,000/hour'),
            const SizedBox(height: 12),
            Text(
              'Rate limit info é retornado nos headers de resposta:',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 8),
            _buildCodeBlock(
              'X-RateLimit-Limit: 60\nX-RateLimit-Remaining: 59\nX-RateLimit-Reset: 2024-01-01T12:01:00Z',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateLimitRow(String tier, String perMin, String perHour) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Chip(
              label: Text(tier, style: const TextStyle(fontSize: 12)),
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text('$perMin  •  $perHour'),
          ),
        ],
      ),
    );
  }

  Widget _buildEndpointsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Endpoints',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildEndpointCard(
          method: 'GET',
          path: '/predictions',
          description: 'Lista previsões da empresa',
          permissions: ['read:predictions'],
          parameters: [
            EndpointParam('page', 'int', 'Página (padrão: 1)', false),
            EndpointParam('per_page', 'int', 'Itens por página (padrão: 20, max: 100)', false),
            EndpointParam('start_date', 'ISO8601', 'Data inicial', false),
            EndpointParam('end_date', 'ISO8601', 'Data final', false),
          ],
          response: '''
{
  "success": true,
  "data": [
    {
      "id": "123",
      "carat": 0.5,
      "cut": "Ideal",
      "color": "E",
      "clarity": "VS1",
      "depth": 61.5,
      "table": 57.0,
      "x": 5.1,
      "y": 5.0,
      "z": 3.1,
      "predicted_price": 2500.50,
      "created_at": "2024-01-01T12:00:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "page": 1,
      "per_page": 20,
      "total": 50,
      "total_pages": 3
    }
  }
}''',
        ),
        const SizedBox(height: 16),
        _buildEndpointCard(
          method: 'POST',
          path: '/predictions',
          description: 'Cria uma nova previsão',
          permissions: ['write:predictions'],
          requestBody: '''
{
  "carat": 0.5,
  "cut": "Ideal",
  "color": "E",
  "clarity": "VS1",
  "depth": 61.5,
  "table": 57.0,
  "x": 5.1,
  "y": 5.0,
  "z": 3.1
}''',
          response: '''
{
  "success": true,
  "message": "Prediction created successfully",
  "data": {
    "id": "124",
    "predicted_price": 2500.50,
    "created_at": "2024-01-01T12:05:00Z"
  }
}''',
        ),
        const SizedBox(height: 16),
        _buildEndpointCard(
          method: 'GET',
          path: '/predictions/:id',
          description: 'Busca uma previsão específica',
          permissions: ['read:predictions'],
          response: '''
{
  "success": true,
  "data": {
    "id": "123",
    "predicted_price": 2500.50,
    "created_at": "2024-01-01T12:00:00Z"
  }
}''',
        ),
        const SizedBox(height: 16),
        _buildEndpointCard(
          method: 'GET',
          path: '/company',
          description: 'Retorna informações da empresa',
          permissions: ['read:company'],
          response: '''
{
  "success": true,
  "data": {
    "id": "comp_123",
    "name": "Acme Corp",
    "subscription_tier": "enterprise",
    "subscription_status": "active",
    "created_at": "2024-01-01T00:00:00Z"
  }
}''',
        ),
        const SizedBox(height: 16),
        _buildEndpointCard(
          method: 'GET',
          path: '/company/usage',
          description: 'Retorna métricas de uso',
          permissions: ['read:analytics'],
          response: '''
{
  "success": true,
  "data": {
    "predictions_this_month": 150,
    "predictions_total": 1200,
    "members_count": 5,
    "api_calls_this_month": 450
  }
}''',
        ),
        const SizedBox(height: 16),
        _buildEndpointCard(
          method: 'GET',
          path: '/company/members',
          description: 'Lista membros da empresa',
          permissions: ['read:users'],
          response: '''
{
  "success": true,
  "data": [
    {
      "id": "mem_123",
      "user_id": "user_456",
      "role": "admin",
      "joined_at": "2024-01-01T00:00:00Z"
    }
  ]
}''',
        ),
      ],
    );
  }

  Widget _buildEndpointCard({
    required String method,
    required String path,
    required String description,
    required List<String> permissions,
    List<EndpointParam>? parameters,
    String? requestBody,
    String? response,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getMethodColor(method),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    method,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    path,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              children: permissions.map((p) {
                return Chip(
                  label: Text(p, style: const TextStyle(fontSize: 10)),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: RadianceColors.info.withOpacity(0.1),
                );
              }).toList(),
            ),
            if (parameters != null && parameters.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Parameters:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...parameters.map((p) => _buildParameter(p)),
            ],
            if (requestBody != null) ...[
              const SizedBox(height: 16),
              const Text('Request Body:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildCodeBlock(requestBody),
            ],
            if (response != null) ...[
              const SizedBox(height: 16),
              const Text('Response:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildCodeBlock(response),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildParameter(EndpointParam param) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            param.name,
            style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Chip(
            label: Text(param.type, style: const TextStyle(fontSize: 10)),
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          if (!param.required)
            const Chip(
              label: Text('optional', style: TextStyle(fontSize: 10)),
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              param.description,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCodesSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Error Codes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildErrorRow('401', 'Unauthorized', 'API key inválida ou ausente'),
            _buildErrorRow('403', 'Forbidden', 'Permissão negada'),
            _buildErrorRow('404', 'Not Found', 'Recurso não encontrado'),
            _buildErrorRow('422', 'Validation Error', 'Dados inválidos'),
            _buildErrorRow('429', 'Rate Limit Exceeded', 'Limite de requisições excedido'),
            _buildErrorRow('500', 'Internal Server Error', 'Erro interno do servidor'),
            const SizedBox(height: 16),
            const Text('Exemplo de resposta de erro:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildCodeBlock('''
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or expired API key"
  }
}'''),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorRow(String code, String name, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: RadianceColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: TextStyle(
                color: RadianceColors.error,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBlock(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          SelectableText(
            code,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.copy, size: 16, color: Colors.white70),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'GET':
        return Colors.blue;
      case 'POST':
        return Colors.green;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class EndpointParam {
  final String name;
  final String type;
  final String description;
  final bool required;

  EndpointParam(this.name, this.type, this.description, [this.required = true]);
}
