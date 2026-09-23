import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/history_model.dart';

class PdfService {
  // ============================================================
  // PDF EMAS FISIK
  // ============================================================

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

    final logoData = await rootBundle.load('assets/images/ewf-logo.png');

    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Stack(
            children: [
              // ==================================================
              // WATERMARK EWF
              // ==================================================
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Opacity(
                    opacity: 0.18,
                    child: pw.Image(
                      logo,
                      width: 500,
                      height: 500,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // ==================================================
              // ISI PDF
              // ==================================================
              pw.Column(
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
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                    ),
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
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // PDF PIVOT EMAS
  // ============================================================

  Future<Uint8List> generatePivotGoldPdf(HistoryModel history) async {
    final input = history.inputData;
    final result = history.resultData;

    final double open = (input['open'] as num).toDouble();
    final double high = (input['high'] as num).toDouble();
    final double low = (input['low'] as num).toDouble();
    final double close = (input['close'] as num).toDouble();

    final double pp = (result['pp'] as num).toDouble();

    final double r1 = (result['r1'] as num).toDouble();
    final double r2 = (result['r2'] as num).toDouble();
    final double r3 = (result['r3'] as num).toDouble();
    final double r4 = (result['r4'] as num).toDouble();

    final double s1 = (result['s1'] as num).toDouble();
    final double s2 = (result['s2'] as num).toDouble();
    final double s3 = (result['s3'] as num).toDouble();
    final double s4 = (result['s4'] as num).toDouble();

    final double midpointR4R3 = (result['midpoint_r4_r3'] as num).toDouble();
    final double midpointR3R2 = (result['midpoint_r3_r2'] as num).toDouble();
    final double midpointR2R1 = (result['midpoint_r2_r1'] as num).toDouble();
    final double midpointPPR1 = (result['midpoint_pp_r1'] as num).toDouble();

    final double midpointPPS1 = (result['midpoint_pp_s1'] as num).toDouble();
    final double midpointS1S2 = (result['midpoint_s1_s2'] as num).toDouble();
    final double midpointS2S3 = (result['midpoint_s2_s3'] as num).toDouble();
    final double midpointS3S4 = (result['midpoint_s3_s4'] as num).toDouble();

    final String indication = result['indication'] as String;

    final date = history.createdAt.toLocal();

    final pdf = pw.Document();

    final logoData = await rootBundle.load('assets/images/ewf-logo.png');
    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Stack(
            children: [
              // ==================================================
              // WATERMARK EWF
              // ==================================================
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Opacity(
                    opacity: 0.18,
                    child: pw.Image(
                      logo,
                      width: 500,
                      height: 500,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // ==================================================
              // ISI PDF
              // ==================================================
              pw.Column(
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
                    'Hasil Perhitungan Pivot Emas',
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
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  pw.Text(
                    'DATA PASAR',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  _buildRow('Open', open.toStringAsFixed(2)),
                  _buildRow('High', high.toStringAsFixed(2)),
                  _buildRow('Low', low.toStringAsFixed(2)),
                  _buildRow('Close', close.toStringAsFixed(2)),

                  pw.SizedBox(height: 12),

                  pw.Divider(),

                  pw.SizedBox(height: 12),

                  pw.Text(
                    'PIVOT POINT',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  // ==================================================
                  // PIVOT POINT + INDIKASI
                  // ==================================================
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.orange100,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Pivot Point (PP)',
                                style: const pw.TextStyle(fontSize: 11),
                              ),

                              pw.SizedBox(height: 3),

                              pw.Text(
                                'INDIKASI: $indication',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                  color: indication == 'BUY'
                                      ? PdfColors.green
                                      : PdfColors.red,
                                ),
                              ),
                            ],
                          ),
                        ),

                        pw.Text(
                          pp.toStringAsFixed(2),
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 15),

                  // ==================================================
                  // LEVEL PIVOT
                  // ==================================================
                  pw.Text(
                    'LEVEL PIVOT',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  _buildRow('R4', r4.toStringAsFixed(2)),
                  _buildRow('Midpoint R4-R3', midpointR4R3.toStringAsFixed(2)),
                  _buildRow('R3', r3.toStringAsFixed(2)),
                  _buildRow('Midpoint R3-R2', midpointR3R2.toStringAsFixed(2)),
                  _buildRow('R2', r2.toStringAsFixed(2)),
                  _buildRow('Midpoint R2-R1', midpointR2R1.toStringAsFixed(2)),
                  _buildRow('R1', r1.toStringAsFixed(2)),
                  _buildRow('Midpoint PP-R1', midpointPPR1.toStringAsFixed(2)),

                  _buildRow('PP', pp.toStringAsFixed(2)),
                  _buildRow('Midpoint PP-S1', midpointPPS1.toStringAsFixed(2)),

                  _buildRow('S1', s1.toStringAsFixed(2)),
                  _buildRow('Midpoint S1-S2', midpointS1S2.toStringAsFixed(2)),
                  _buildRow('S2', s2.toStringAsFixed(2)),
                  _buildRow('Midpoint S2-S3', midpointS2S3.toStringAsFixed(2)),
                  _buildRow('S3', s3.toStringAsFixed(2)),
                  _buildRow('Midpoint S3-S4', midpointS3S4.toStringAsFixed(2)),
                  _buildRow('S4', s4.toStringAsFixed(2)),

                  pw.Spacer(),

                  pw.Divider(),

                  pw.SizedBox(height: 5),

                  pw.Text(
                    'AURUM - Hasil Perhitungan',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // PDF NEST
  // ============================================================

  Future<Uint8List> generateNestPdf(HistoryModel history) async {
    final input = history.inputData;
    final result = history.resultData;

    final double open = (input['open'] as num).toDouble();
    final double close = (input['close'] as num).toDouble();

    final String indication = result['indication'].toString();
    final String description = result['description'].toString();

    final date = history.createdAt.toLocal();

    final pdf = pw.Document();

    final logoData = await rootBundle.load('assets/images/ewf-logo.png');
    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Stack(
            children: [
              // ==================================================
              // WATERMARK EWF
              // ==================================================
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Opacity(
                    opacity: 0.18,
                    child: pw.Image(
                      logo,
                      width: 500,
                      height: 500,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // ==================================================
              // ISI PDF
              // ==================================================
              pw.Column(
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
                    'Hasil Perhitungan Nest',
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
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // ==================================================
                  // DATA PASAR
                  // ==================================================
                  pw.Text(
                    'DATA PASAR',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  _buildRow('Open', _formatNumber(open)),
                  _buildRow('Close', _formatNumber(close)),

                  pw.SizedBox(height: 15),

                  // ==================================================
                  // INDIKASI
                  // ==================================================
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(14),
                    decoration: pw.BoxDecoration(
                      color: indication == 'BUY'
                          ? PdfColors.green100
                          : indication == 'SELL'
                          ? PdfColors.red100
                          : PdfColors.grey200,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'INDIKASI',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey700,
                          ),
                        ),

                        pw.SizedBox(height: 5),

                        pw.Text(
                          indication,
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: indication == 'BUY'
                                ? PdfColors.green
                                : indication == 'SELL'
                                ? PdfColors.red
                                : PdfColors.grey800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 18),

                  // ==================================================
                  // ANALISIS
                  // ==================================================
                  pw.Text(
                    'ANALISIS',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(14),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(
                      description,
                      style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
                    ),
                  ),

                  pw.Spacer(),

                  pw.Divider(),

                  pw.SizedBox(height: 5),

                  pw.Text(
                    'AURUM - Hasil Perhitungan',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // HELPER PDF
  // ============================================================
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

  // ============================================================
  // PDF PIVOT HANG SENG
  // ============================================================

  Future<Uint8List> generateHangSengPdf(HistoryModel history) async {
    final input = history.inputData;
    final result = history.resultData;

    final double open = (input['open'] as num).toDouble();
    final double high = (input['high'] as num).toDouble();
    final double low = (input['low'] as num).toDouble();
    final double close = (input['close'] as num).toDouble();

    final double pp = (result['pp'] as num).toDouble();

    final double r1 = (result['r1'] as num).toDouble();
    final double r2 = (result['r2'] as num).toDouble();
    final double r3 = (result['r3'] as num).toDouble();
    final double r4 = (result['r4'] as num).toDouble();

    final double s1 = (result['s1'] as num).toDouble();
    final double s2 = (result['s2'] as num).toDouble();
    final double s3 = (result['s3'] as num).toDouble();
    final double s4 = (result['s4'] as num).toDouble();

    final double midpointR4R3 = (result['midpoint_r4_r3'] as num).toDouble();
    final double midpointR3R2 = (result['midpoint_r3_r2'] as num).toDouble();
    final double midpointR2R1 = (result['midpoint_r2_r1'] as num).toDouble();
    final double midpointPPR1 = (result['midpoint_pp_r1'] as num).toDouble();

    final double midpointPPS1 = (result['midpoint_pp_s1'] as num).toDouble();
    final double midpointS1S2 = (result['midpoint_s1_s2'] as num).toDouble();
    final double midpointS2S3 = (result['midpoint_s2_s3'] as num).toDouble();
    final double midpointS3S4 = (result['midpoint_s3_s4'] as num).toDouble();

    final String indication = result['indication'].toString();

    final date = history.createdAt.toLocal();

    final pdf = pw.Document();

    final logoData = await rootBundle.load('assets/images/ewf-logo.png');
    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Stack(
            children: [
              // ==================================================
              // WATERMARK EWF
              // ==================================================
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Opacity(
                    opacity: 0.18,
                    child: pw.Image(
                      logo,
                      width: 500,
                      height: 500,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // ==================================================
              // ISI PDF
              // ==================================================
              pw.Column(
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
                    'Hasil Perhitungan Pivot Hang Seng',
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
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  pw.Text(
                    'DATA PASAR',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  _buildRow('Open', open.toStringAsFixed(2)),
                  _buildRow('High', high.toStringAsFixed(2)),
                  _buildRow('Low', low.toStringAsFixed(2)),
                  _buildRow('Close', close.toStringAsFixed(2)),

                  pw.SizedBox(height: 12),

                  pw.Divider(),

                  pw.SizedBox(height: 12),

                  pw.Text(
                    'PIVOT POINT',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  // ==================================================
                  // PIVOT POINT + INDIKASI
                  // ==================================================
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.orange100,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Pivot Point (PP)',
                                style: const pw.TextStyle(fontSize: 11),
                              ),

                              pw.SizedBox(height: 3),

                              pw.Text(
                                'INDIKASI: $indication',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                  color: indication == 'BUY'
                                      ? PdfColors.green
                                      : PdfColors.red,
                                ),
                              ),
                            ],
                          ),
                        ),

                        pw.Text(
                          pp.toStringAsFixed(2),
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 15),

                  // ==================================================
                  // LEVEL PIVOT
                  // ==================================================
                  pw.Text(
                    'LEVEL PIVOT',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  _buildRow('R4', r4.toStringAsFixed(2)),
                  _buildRow('Midpoint R4-R3', midpointR4R3.toStringAsFixed(2)),
                  _buildRow('R3', r3.toStringAsFixed(2)),
                  _buildRow('Midpoint R3-R2', midpointR3R2.toStringAsFixed(2)),
                  _buildRow('R2', r2.toStringAsFixed(2)),
                  _buildRow('Midpoint R2-R1', midpointR2R1.toStringAsFixed(2)),
                  _buildRow('R1', r1.toStringAsFixed(2)),
                  _buildRow('Midpoint PP-R1', midpointPPR1.toStringAsFixed(2)),

                  _buildRow('PP', pp.toStringAsFixed(2)),
                  _buildRow('Midpoint PP-S1', midpointPPS1.toStringAsFixed(2)),

                  _buildRow('S1', s1.toStringAsFixed(2)),
                  _buildRow('Midpoint S1-S2', midpointS1S2.toStringAsFixed(2)),
                  _buildRow('S2', s2.toStringAsFixed(2)),
                  _buildRow('Midpoint S2-S3', midpointS2S3.toStringAsFixed(2)),
                  _buildRow('S3', s3.toStringAsFixed(2)),
                  _buildRow('Midpoint S3-S4', midpointS3S4.toStringAsFixed(2)),
                  _buildRow('S4', s4.toStringAsFixed(2)),

                  pw.Spacer(),

                  pw.Divider(),

                  pw.SizedBox(height: 5),

                  pw.Text(
                    'AURUM - Hasil Perhitungan',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // FORMAT ANGKA
  // ============================================================
  String _formatNumber(double value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }
}
