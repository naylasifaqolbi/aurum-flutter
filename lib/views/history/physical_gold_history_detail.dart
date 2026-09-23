import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';

import '../../models/history_model.dart';
import '../../services/pdf_service.dart';
import '../../viewmodels/history_viewmodel.dart';

class PhysicalGoldHistoryDetail extends StatelessWidget {
  final HistoryModel history;

  const PhysicalGoldHistoryDetail({super.key, required this.history});

  // ============================================================
  // COLOR
  // ============================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color orangeColor = Color(0xFFF28C28);
  static const Color darkBrown = Color(0xFF3D2B1F);
  static const Color lightOrange = Color(0xFFFFE5CC);
  static const Color greenColor = Color(0xFF00B87A);
  static const Color lightGreen = Color(0xFFEAFBF5);

  @override
  Widget build(BuildContext context) {
    final input = history.inputData;
    final result = history.resultData;
    final date = history.createdAt.toLocal();

    final double modal = (input['modal'] as num).toDouble();
    final double kurs = (input['kurs'] as num).toDouble();
    final double hargaBeli = (input['harga_beli'] as num).toDouble();
    final double hargaJual = (input['harga_jual'] as num).toDouble();

    final double toz = (result['toz'] as num).toDouble();
    final double keuntungan = (result['keuntungan'] as num).toDouble();

    return Scaffold(
      backgroundColor: backgroundColor,

      // ============================================================
      // HEADER
      // ============================================================
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
            color: darkBrown,
            size: 25,
          ),
        ),

        title: const Text(
          'Detail Riwayat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: orangeColor,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // DETAIL HEADER
              // ==================================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Text(
                      'DETAIL RIWAYAT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: orangeColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: orangeColor, width: 1),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.monetization_on_outlined,
                          color: orangeColor,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'KALKULATOR EMAS FISIK',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: orangeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                '${date.day.toString().padLeft(2, '0')} '
                '${_getMonthName(date.month)} '
                '${date.year}, '
                '${date.hour.toString().padLeft(2, '0')}:'
                '${date.minute.toString().padLeft(2, '0')} WIB',
                style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // MAIN DETAIL CARD
              // ==================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(19, 20, 19, 19),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: const Color(0xFFE1E7EF), width: 1),
                ),

                child: Stack(
                  children: [
                    // ==================================================
                    // LOGO EWF SEBAGAI WATERMARK
                    // ==================================================
                    Positioned.fill(
                      child: Center(
                        child: Opacity(
                          opacity: 0.35,
                          child: Image.asset(
                            'assets/images/ewf-logo.png',
                            width: 300,
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    // ==================================================
                    // ISI CARD
                    // ==================================================
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==================================================
                        // TRANSAKSI
                        // ==================================================
                        const Text(
                          'TRANSAKSI',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF667085),
                          ),
                        ),

                        const SizedBox(height: 13),

                        _buildTransactionRow(
                          'Modal',
                          'Rp ${_formatNumber(modal)}',
                        ),

                        _buildTransactionRow(
                          'Kurs',
                          'Rp ${_formatNumber(kurs)}',
                        ),

                        _buildTransactionRow(
                          'TOz',
                          toz.toStringAsFixed(1).replaceAll('.', ','),
                        ),

                        _buildTransactionRow(
                          'Harga Beli',
                          _formatNumber(hargaBeli),
                        ),

                        _buildTransactionRow(
                          'Harga Jual',
                          _formatNumber(hargaJual),
                        ),

                        const SizedBox(height: 9),

                        const Divider(height: 1, color: Color(0xFFECEFF3)),

                        const SizedBox(height: 16),

                        // ==================================================
                        // HASIL PERHITUNGAN
                        // ==================================================
                        const Text(
                          'HASIL PERHITUNGAN',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF667085),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFAE9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFFE5A8),
                              width: 1,
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Estimasi Keuntungan Bersih',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF667085),
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                '${keuntungan >= 0 ? '+ ' : '- '}Rp ${_formatNumber(keuntungan.abs())}',
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: orangeColor,
                                ),
                              ),

                              const SizedBox(height: 5),

                              const Text(
                                'Keuntungan dari transaksi emas fisik',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF667085),
                                ),
                              ),

                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // ==================================================
              // DOWNLOAD BUTTON
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final pdfService = PdfService();

                    final pdfBytes = await pdfService.generatePhysicalGoldPdf(
                      history,
                    );

                    await Printing.sharePdf(
                      bytes: pdfBytes,
                      filename: 'hasil_emas_fisik.pdf',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.download_rounded, size: 20),
                  label: const Text(
                    'Unduh Hasil Perhitungan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 9),

              // ==================================================
              // DELETE BUTTON
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Hapus Riwayat?'),
                          content: const Text(
                            'Riwayat perhitungan ini akan dihapus secara permanen.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text(
                                'Batal',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm != true) {
                      return;
                    }

                    final deleted = await context
                        .read<HistoryViewModel>()
                        .deleteHistory(history.id);

                    if (!context.mounted) {
                      return;
                    }

                    if (deleted) {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Riwayat berhasil dihapus.'),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  label: const Text(
                    'Hapus Riwayat',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TRANSACTION ROW
  // ============================================================

  Widget _buildTransactionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xFF667085)),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkBrown,
            ),
          ),
        ],
      ),
    );
  }
  // ============================================================
  // FORMAT NUMBER
  // ============================================================

  String _formatNumber(double value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }

  // ============================================================
  // MONTH NAME
  // ============================================================

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return months[month - 1];
  }
}
