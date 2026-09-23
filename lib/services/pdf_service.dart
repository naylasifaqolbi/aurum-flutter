import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/history_model.dart';

class PdfService {
  Future<Uint8List> generatePhysicalGoldPdf(HistoryModel history) async {
    final input = history.inputData;
    final result = history.resultData;

    final double modal = (input['modal'] as num).toDouble();
    final double kurs = (input['kurs'] as num).toDouble();
    final double hargaBeli = (input['harga_beli'] as num).toDouble();
    final double hargaJual = (input['harga_jual'] as num).toDouble();

    final double toz = (result['toz'] as num).toDouble();
    final double keuntungan = (result['keuntungan'] as num).toDouble();

    final date = history.createdAt.toLocal();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'AURUM',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.orange,
                ),
              ),

              pw.SizedBox(height: 4),

              pw.Text(
                'Hasil Perhitungan Emas Fisik',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 6),

              pw.Text(
                '${date.day.toString().padLeft(2, '0')}/'
                '${date.month.toString().padLeft(2, '0')}/'
                '${date.year} '
                '${date.hour.toString().padLeft(2, '0')}:'
                '${date.minute.toString().padLeft(2, '0')}',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),

              pw.SizedBox(height: 25),

              pw.Text(
                'TRANSAKSI',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              _buildRow('Modal', 'Rp ${_formatNumber(modal)}'),
              _buildRow('Kurs', 'Rp ${_formatNumber(kurs)}'),
              _buildRow('TOz', toz.toStringAsFixed(1).replaceAll('.', ',')),
              _buildRow('Harga Beli', _formatNumber(hargaBeli)),
              _buildRow('Harga Jual', _formatNumber(hargaJual)),

              pw.SizedBox(height: 20),

              pw.Divider(),

              pw.SizedBox(height: 15),

              pw.Text(
                'HASIL PERHITUNGAN',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  color: PdfColors.orange100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Estimasi Keuntungan Bersih',
                      style: const pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey,
                      ),
                    ),

                    pw.SizedBox(height: 5),

                    pw.Text(
                      '${keuntungan >= 0 ? '+ ' : '- '}'
                      'Rp ${_formatNumber(keuntungan.abs())}',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.orange,
                      ),
                    ),

                    pw.SizedBox(height: 5),

                    pw.Text(
                      'Keuntungan dari transaksi emas fisik',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              pw.Divider(),

              pw.SizedBox(height: 5),

              pw.Text(
                'AURUM - Hasil Perhitungan',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(label, style: const pw.TextStyle(fontSize: 11)),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }
}
