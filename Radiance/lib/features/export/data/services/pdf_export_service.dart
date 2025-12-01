import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/export_config.dart';
import '../../../../core/data/models/prediction_model.dart';

/// Serviço de exportação para PDF
class PdfExportService {
  /// Gera PDF de relatório de previsões
  Future<ExportResult> generatePredictionsReport({
    required List<PredictionHistoryModel> predictions,
    required ExportConfig config,
    String? companyName,
  }) async {
    final pdf = pw.Document();

    // Página de capa
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => _buildCoverPage(
          companyName: companyName ?? 'Radiance B2B',
          reportTitle: 'Relatório de Previsões',
          startDate: config.startDate,
          endDate: config.endDate,
          totalPredictions: predictions.length,
        ),
      ),
    );

    // Página de resumo
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => _buildSummaryPage(predictions),
      ),
    );

    // Páginas de detalhes
    if (config.includeDetails) {
      final chunks = _chunkList(predictions, 15); // 15 previsões por página
      for (final chunk in chunks) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) => _buildDetailsPage(chunk),
          ),
        );
      }
    }

    // Salvar arquivo
    final output = await _getOutputDirectory();
    final fileName = 'predictions_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return ExportResult(
      filePath: file.path,
      fileName: fileName,
      fileSize: await file.length(),
      format: ExportFormat.pdf,
      generatedAt: DateTime.now(),
    );
  }

  pw.Widget _buildCoverPage({
    required String companyName,
    required String reportTitle,
    required DateTime startDate,
    required DateTime endDate,
    required int totalPredictions,
  }) {
    return pw.Center(
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            companyName,
            style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            reportTitle,
            style: const pw.TextStyle(fontSize: 24, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 40),
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Column(
              children: [
                _buildInfoRow('Período', '${_formatDate(startDate)} a ${_formatDate(endDate)}'),
                pw.SizedBox(height: 10),
                _buildInfoRow('Total de Previsões', totalPredictions.toString()),
                pw.SizedBox(height: 10),
                _buildInfoRow('Gerado em', _formatDate(DateTime.now())),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummaryPage(List<PredictionHistoryModel> predictions) {
    final avgPrice = predictions.isEmpty
        ? 0.0
        : predictions.map((p) => p.predictedPrice).reduce((a, b) => a + b) / predictions.length;

    final maxPrice = predictions.isEmpty
        ? 0.0
        : predictions.map((p) => p.predictedPrice).reduce((a, b) => a > b ? a : b);

    final minPrice = predictions.isEmpty
        ? 0.0
        : predictions.map((p) => p.predictedPrice).reduce((a, b) => a < b ? a : b);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Resumo Executivo',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 20),
        pw.Divider(),
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            _buildStatCard('Total', predictions.length.toString(), PdfColors.blue),
            _buildStatCard('Média', 'R\$ ${avgPrice.toStringAsFixed(2)}', PdfColors.green),
            _buildStatCard('Máximo', 'R\$ ${maxPrice.toStringAsFixed(2)}', PdfColors.orange),
            _buildStatCard('Mínimo', 'R\$ ${minPrice.toStringAsFixed(2)}', PdfColors.purple),
          ],
        ),
        pw.SizedBox(height: 40),
        pw.Text(
          'Distribuição por Faixa de Preço',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 15),
        _buildPriceDistribution(predictions),
      ],
    );
  }

  pw.Widget _buildDetailsPage(List<PredictionHistoryModel> predictions) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Detalhes das Previsões',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 15),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('Data', isHeader: true),
                _buildTableCell('Quilates', isHeader: true),
                _buildTableCell('Cor', isHeader: true),
                _buildTableCell('Clareza', isHeader: true),
                _buildTableCell('Preço', isHeader: true),
              ],
            ),
            // Rows
            ...predictions.map((p) => pw.TableRow(
                  children: [
                    _buildTableCell(_formatDate(p.createdAt)),
                    _buildTableCell(p.carat.toStringAsFixed(2)),
                    _buildTableCell(p.color),
                    _buildTableCell(p.clarity),
                    _buildTableCell('R\$ ${p.predictedPrice.toStringAsFixed(2)}'),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildStatCard(String label, String value, PdfColor color) {
    return pw.Container(
      width: 100,
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: color),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPriceDistribution(List<PredictionHistoryModel> predictions) {
    final ranges = {
      'Até R\$ 5.000': predictions.where((p) => p.predictedPrice <= 5000).length,
      'R\$ 5.001 - R\$ 10.000': predictions.where((p) => p.predictedPrice > 5000 && p.predictedPrice <= 10000).length,
      'R\$ 10.001 - R\$ 20.000': predictions.where((p) => p.predictedPrice > 10000 && p.predictedPrice <= 20000).length,
      'Acima de R\$ 20.000': predictions.where((p) => p.predictedPrice > 20000).length,
    };

    return pw.Column(
      children: ranges.entries.map((entry) {
        final percentage = predictions.isEmpty ? 0.0 : (entry.value / predictions.length) * 100;
        return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Row(
            children: [
              pw.SizedBox(
                width: 150,
                child: pw.Text(entry.key, style: const pw.TextStyle(fontSize: 12)),
              ),
              pw.Expanded(
                child: pw.Container(
                  height: 20,
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  child: pw.Stack(
                    children: [
                      pw.Container(
                        width: percentage * 3, // Max 300px width
                        decoration: const pw.BoxDecoration(color: PdfColors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Text('${entry.value} (${percentage.toStringAsFixed(1)}%)', 
                style: const pw.TextStyle(fontSize: 11)),
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(value),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    final chunks = <List<T>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  Future<Directory> _getOutputDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/exports');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    return exportDir;
  }
}
