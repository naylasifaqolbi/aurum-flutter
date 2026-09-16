import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:external_path/external_path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PhysicalGoldResult extends StatelessWidget {
  final double modal;
  final double kurs;
  final double hargaBeli;
  final double hargaJual;

  final double hasilHargaBeli;
  final double hasilHargaJual;
  final double selisihHarga;
  final double jumlahEmas;
  final double keuntungan;

  const PhysicalGoldResult({
    super.key,
    required this.modal,
    required this.kurs,
    required this.hargaBeli,
    required this.hargaJual,
    required this.hasilHargaBeli,
    required this.hasilHargaJual,
    required this.selisihHarga,
    required this.jumlahEmas,
    required this.keuntungan,
  });

  // ==================================================
  // FORMAT ANGKA
  // ==================================================

  String _formatNumber(double value) {
    return value.toStringAsFixed(2);
  }

  String _formatRupiah(double value) {
    final rounded = value.round();

    final formatted = rounded.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return 'Rp $formatted';
  }

  // ==================================================
  // MEMBUAT PDF HASIL PERHITUNGAN
  // ==================================================

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    // ==================================================
    // MENGAMBIL LOGO DARI ASSETS
    // ==================================================

    final ByteData logoData = await rootBundle.load(
      'assets/images/ewf-logo.png',
    );

    final Uint8List logoBytes = logoData.buffer.asUint8List(
      logoData.offsetInBytes,
      logoData.lengthInBytes,
    );

    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    final bool isProfit = keuntungan >= 0;

    // ==================================================
    // WARNA PDF
    // ==================================================

    final PdfColor orangePdf = PdfColor.fromHex('#F28C28');
    final PdfColor darkBrownPdf = PdfColor.fromHex('#3D2B1F');
    final PdfColor lightOrangePdf = PdfColor.fromHex('#FFE5CC');
    final PdfColor lightRedPdf = PdfColor.fromHex('#FFE2E2');
    final PdfColor greyPdf = PdfColor.fromHex('#777777');
    final PdfColor borderPdf = PdfColor.fromHex('#E5E5E5');

    // ==================================================
    // HALAMAN PDF SATU HALAMAN A4
    // ==================================================

    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 28),

          // ==================================================
          // WATERMARK
          // ==================================================
          buildBackground: (pw.Context context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Center(
                child: pw.Opacity(
                  opacity: 0.07,
                  child: pw.Image(
                    logoImage,
                    width: 260,
                    height: 260,
                    fit: pw.BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        ),

        // ==================================================
        // HEADER DAN ISI PDF
        // ==================================================
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ==================================================
              // HEADER PDF
              // ==================================================
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'AURUM',
                        style: pw.TextStyle(
                          color: orangePdf,
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Gold Analysis & Calculator',
                        style: pw.TextStyle(color: darkBrownPdf, fontSize: 9),
                      ),
                    ],
                  ),
                  pw.Text(
                    'HASIL PERHITUNGAN',
                    style: pw.TextStyle(
                      color: darkBrownPdf,
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 10),

              pw.Divider(color: borderPdf, thickness: 1),

              pw.SizedBox(height: 12),

              // ==================================================
              // JUDUL
              // ==================================================
              pw.Text(
                'Hasil Emas Fisik',
                style: pw.TextStyle(
                  color: orangePdf,
                  fontSize: 19,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 3),

              pw.Text(
                'Berikut hasil perhitungan transaksi emas fisik.',
                style: pw.TextStyle(color: greyPdf, fontSize: 9),
              ),

              pw.SizedBox(height: 12),

              // ==================================================
              // HASIL UTAMA
              // ==================================================
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: pw.BoxDecoration(
                  color: isProfit ? lightOrangePdf : lightRedPdf,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      isProfit ? 'KEUNTUNGAN' : 'KERUGIAN',
                      style: pw.TextStyle(
                        color: isProfit ? orangePdf : PdfColors.red,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),

                    pw.SizedBox(height: 4),

                    pw.Text(
                      _formatRupiah(keuntungan.abs()),
                      style: pw.TextStyle(
                        color: isProfit ? orangePdf : PdfColors.red,
                        fontSize: 21,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 14),

              // ==================================================
              // DATA TRANSAKSI
              // ==================================================
              pw.Text(
                'Data Transaksi',
                style: pw.TextStyle(
                  color: darkBrownPdf,
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 6),

              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: borderPdf),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    _buildPdfDataRow(
                      title: 'Modal',
                      value: _formatRupiah(modal),
                      darkBrownPdf: darkBrownPdf,
                      greyPdf: greyPdf,
                    ),

                    _buildPdfDivider(),

                    _buildPdfDataRow(
                      title: 'Kurs',
                      value: _formatRupiah(kurs),
                      darkBrownPdf: darkBrownPdf,
                      greyPdf: greyPdf,
                    ),

                    _buildPdfDivider(),

                    _buildPdfDataRow(
                      title: 'Harga Beli',
                      value: _formatNumber(hargaBeli),
                      darkBrownPdf: darkBrownPdf,
                      greyPdf: greyPdf,
                    ),

                    _buildPdfDivider(),

                    _buildPdfDataRow(
                      title: 'Harga Jual',
                      value: _formatNumber(hargaJual),
                      darkBrownPdf: darkBrownPdf,
                      greyPdf: greyPdf,
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 14),

              // ==================================================
              // RINCIAN PERHITUNGAN
              // ==================================================
              pw.Text(
                'Rincian Perhitungan',
                style: pw.TextStyle(
                  color: darkBrownPdf,
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 6),

              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: borderPdf),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // TAHAP 1
                    // ==================================================
                    _buildPdfCalculationStep(
                      number: '1',
                      title: 'Harga Beli × Kurs ÷ Toz',
                      formula:
                          '${_formatNumber(hargaBeli)} × '
                          '${_formatNumber(kurs)} ÷ 31.1',
                      result: _formatNumber(hasilHargaBeli),
                      orangePdf: orangePdf,
                      darkBrownPdf: darkBrownPdf,
                      greyPdf: greyPdf,
                    ),

                    pw.SizedBox(height: 9),

                    // ==================================================
                    // TAHAP 2
                    // ==================================================
                    _buildPdfCalculationStep(
                      number: '2',
                      title: 'Harga Jual × Kurs ÷ Toz',
                      formula:
                          '${_formatNumber(hargaJual)} × '
                          '${_formatNumber(kurs)} ÷ 31.1',
                      result: _formatNumber(hasilHargaJual),
                      orangePdf: orangePdf,
                      darkBrownPdf: darkBrownPdf,
                      greyPdf: greyPdf,
                    ),

                    pw.SizedBox(height: 9),

                    // ==================================================
                    // TAHAP 3
                    // Simbol minus menggunakan '-' biasa
                    // agar dapat muncul pada PDF.
                    // ==================================================
                    _buildPdfCalculationStep(
                      number: '3',
                      title: 'Hasil Harga Jual - Hasil Harga Beli',
                      formula:
                          '${_formatNumber(hasilHargaJual)} - '
                          '${_formatNumber(hasilHargaBeli)}',
                      result: _formatNumber(selisihHarga),
                      orangePdf: orangePdf,
                      darkBrownPdf: darkBrownPdf,
                      greyPdf: greyPdf,
                    ),

                    pw.SizedBox(height: 9),

                    // ==================================================
                    // TAHAP 4
                    // ==================================================
                    _buildPdfCalculationStep(
                      number: '4',
                      title: 'Modal ÷ Hasil Harga Jual',
                      formula:
                          '${_formatNumber(modal)} ÷ '
                          '${_formatNumber(hasilHargaJual)}',
                      result: _formatNumber(jumlahEmas),
                      orangePdf: orangePdf,
                      darkBrownPdf: darkBrownPdf,
                      greyPdf: greyPdf,
                    ),

                    pw.SizedBox(height: 9),

                    // ==================================================
                    // TAHAP 5
                    // ==================================================
                    _buildPdfCalculationStep(
                      number: '5',
                      title: 'Selisih Harga × Jumlah Emas',
                      formula:
                          '${_formatNumber(selisihHarga)} × '
                          '${_formatNumber(jumlahEmas)}',
                      result: _formatRupiah(keuntungan),
                      orangePdf: orangePdf,
                      darkBrownPdf: darkBrownPdf,
                      greyPdf: greyPdf,
                      resultColor: isProfit ? orangePdf : PdfColors.red,
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              // ==================================================
              // FOOTER DOKUMEN
              // ==================================================
              pw.Divider(color: borderPdf, thickness: 1),

              pw.SizedBox(height: 5),

              pw.Center(
                child: pw.Text(
                  'Dokumen ini dibuat oleh aplikasi AURUM.',
                  style: pw.TextStyle(color: greyPdf, fontSize: 8),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ==================================================
  // DOWNLOAD PDF KE PENYIMPANAN PERANGKAT
  // ==================================================

  Future<void> _downloadResult(BuildContext context) async {
    try {
      // Membuat file PDF terlebih dahulu
      final Uint8List pdfBytes = await _generatePdf();

      String downloadPath;

      // ==================================================
      // ANDROID
      // ==================================================

      if (Platform.isAndroid) {
        downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOAD,
        );
      }
      // ==================================================
      // WINDOWS / PLATFORM LAIN
      // ==================================================
      else {
        downloadPath = '.';
      }

      final Directory directory = Directory(downloadPath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Nama file menggunakan timestamp agar tidak tertimpa
      final String fileName =
          'hasil_emas_fisik_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final String filePath = '$downloadPath/$fileName';

      final File file = File(filePath);

      // Menyimpan file PDF ke penyimpanan perangkat
      await file.writeAsBytes(pdfBytes, flush: true);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF berhasil disimpan di folder Download.\n$fileName'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan PDF: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // ==================================================
  // PDF DATA ROW
  // ==================================================

  pw.Widget _buildPdfDataRow({
    required String title,
    required String value,
    required PdfColor darkBrownPdf,
    required PdfColor greyPdf,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(title, style: pw.TextStyle(color: greyPdf, fontSize: 9)),

        pw.Text(
          value,
          style: pw.TextStyle(
            color: darkBrownPdf,
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfDivider() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Divider(color: PdfColor.fromHex('#EEEEEE'), thickness: 0.5),
    );
  }

  // ==================================================
  // PDF CALCULATION STEP
  // ==================================================

  pw.Widget _buildPdfCalculationStep({
    required String number,
    required String title,
    required String formula,
    required String result,
    required PdfColor orangePdf,
    required PdfColor darkBrownPdf,
    required PdfColor greyPdf,
    PdfColor? resultColor,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 20,
          height: 20,
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('#FFE5CC'),
            shape: pw.BoxShape.circle,
          ),
          child: pw.Center(
            child: pw.Text(
              number,
              style: pw.TextStyle(
                color: orangePdf,
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ),

        pw.SizedBox(width: 8),

        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  color: darkBrownPdf,
                  fontSize: 8.5,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 2),

              pw.Text(
                formula,
                style: pw.TextStyle(color: greyPdf, fontSize: 8),
              ),

              pw.SizedBox(height: 2),

              pw.Text(
                '= $result',
                style: pw.TextStyle(
                  color: resultColor ?? orangePdf,
                  fontSize: 8.5,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================================================
  // TAMPILAN HALAMAN HASIL
  // ==================================================

  @override
  Widget build(BuildContext context) {
    final bool isProfit = keuntungan >= 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      // ==================================================
      // HEADER
      // ==================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
        ),

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF3D2B1F),
            size: 25,
          ),
        ),

        title: const Text(
          'Hasil Emas Fisik',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF28C28),
          ),
        ),
      ),

      // ==================================================
      // BODY
      // ==================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TITLE
              // ==================================================
              const Text(
                'Hasil Kalkulasi',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF28C28),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Berikut hasil perhitungan transaksi emas fisik Anda.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777777),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // HASIL UTAMA
              // ==================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: isProfit
                      ? const Color(0xFFFFE5CC)
                      : const Color(0xFFFFE2E2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      isProfit
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 42,
                      color: isProfit ? const Color(0xFFF28C28) : Colors.red,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      isProfit ? 'Keuntungan' : 'Kerugian',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF777777),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      _formatRupiah(keuntungan.abs()),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isProfit ? const Color(0xFFF28C28) : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // DATA INPUT
              // ==================================================
              const Text(
                'Data Transaksi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D2B1F),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildResultItem(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Modal',
                      value: _formatRupiah(modal),
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    _buildResultItem(
                      icon: Icons.currency_exchange_rounded,
                      title: 'Kurs',
                      value: _formatRupiah(kurs),
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    _buildResultItem(
                      icon: Icons.shopping_cart_outlined,
                      title: 'Harga Beli',
                      value: _formatNumber(hargaBeli),
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    _buildResultItem(
                      icon: Icons.sell_outlined,
                      title: 'Harga Jual',
                      value: _formatNumber(hargaJual),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // RINCIAN PERHITUNGAN
              // ==================================================
              const Text(
                'Rincian Perhitungan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D2B1F),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCalculationStep(
                      number: '1',
                      title: 'Harga Beli × Kurs ÷ Toz',
                      formula:
                          '${_formatNumber(hargaBeli)} × '
                          '${_formatNumber(kurs)} ÷ 31.1',
                      result: _formatNumber(hasilHargaBeli),
                    ),

                    const SizedBox(height: 18),

                    _buildCalculationStep(
                      number: '2',
                      title: 'Harga Jual × Kurs ÷ Toz',
                      formula:
                          '${_formatNumber(hargaJual)} × '
                          '${_formatNumber(kurs)} ÷ 31.1',
                      result: _formatNumber(hasilHargaJual),
                    ),

                    const SizedBox(height: 18),

                    _buildCalculationStep(
                      number: '3',
                      title: 'Hasil Harga Jual − Hasil Harga Beli',
                      formula:
                          '${_formatNumber(hasilHargaJual)} − '
                          '${_formatNumber(hasilHargaBeli)}',
                      result: _formatNumber(selisihHarga),
                    ),

                    const SizedBox(height: 18),

                    _buildCalculationStep(
                      number: '4',
                      title: 'Modal ÷ Hasil Harga Jual',
                      formula:
                          '${_formatNumber(modal)} ÷ '
                          '${_formatNumber(hasilHargaJual)}',
                      result: _formatNumber(jumlahEmas),
                    ),

                    const SizedBox(height: 18),

                    _buildCalculationStep(
                      number: '5',
                      title: 'Selisih Harga × Jumlah Emas',
                      formula:
                          '${_formatNumber(selisihHarga)} × '
                          '${_formatNumber(jumlahEmas)}',
                      result: _formatRupiah(keuntungan),
                      resultColor: isProfit
                          ? const Color(0xFFF28C28)
                          : Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // ACTION BUTTONS
              // ==================================================

              // HITUNG LAGI
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text(
                    'Hitung Lagi',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF28C28),
                    side: const BorderSide(color: Color(0xFFF28C28)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // UNDUH HASIL
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _downloadResult(context);
                  },
                  icon: const Icon(Icons.download_rounded, size: 20),
                  label: const Text(
                    'Unduh Hasil Perhitungan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF28C28),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // RESULT ITEM
  // ==================================================

  Widget _buildResultItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5CC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFF28C28), size: 22),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, color: Color(0xFF777777)),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3D2B1F),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // CALCULATION STEP
  // ==================================================

  Widget _buildCalculationStep({
    required String number,
    required String title,
    required String formula,
    required String result,
    Color resultColor = const Color(0xFFF28C28),
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFFFE5CC),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFF28C28),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D2B1F),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                formula,
                style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
              ),

              const SizedBox(height: 5),

              Text(
                '= $result',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: resultColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
