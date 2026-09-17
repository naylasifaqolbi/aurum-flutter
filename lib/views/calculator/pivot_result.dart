import 'dart:io';
import 'dart:typed_data';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PivotResult extends StatelessWidget {
  // ============================================================
  // INPUT DATA
  // ============================================================

  final double open;
  final double high;
  final double low;
  final double close;

  // ============================================================
  // PIVOT POINT
  // ============================================================

  final double pp;

  // ============================================================
  // RESISTANCE
  // ============================================================

  final double r1;
  final double r2;
  final double r3;
  final double r4;

  // ============================================================
  // SUPPORT
  // ============================================================

  final double s1;
  final double s2;
  final double s3;
  final double s4;

  // ============================================================
  // MIDPOINT RESISTANCE
  // ============================================================

  final double midpointR4R3;
  final double midpointR3R2;
  final double midpointR2R1;
  final double midpointPPR1;

  // ============================================================
  // MIDPOINT SUPPORT
  // ============================================================

  final double midpointPPS1;
  final double midpointS1S2;
  final double midpointS2S3;
  final double midpointS3S4;

  // ============================================================
  // INDIKASI
  // ============================================================

  final String indication;

  // ============================================================
  // JENIS PIVOT
  // ============================================================

  final String pivotType;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  const PivotResult({
    super.key,

    required this.open,
    required this.high,
    required this.low,
    required this.close,

    required this.pp,

    required this.r1,
    required this.r2,
    required this.r3,
    required this.r4,

    required this.s1,
    required this.s2,
    required this.s3,
    required this.s4,

    required this.midpointR4R3,
    required this.midpointR3R2,
    required this.midpointR2R1,
    required this.midpointPPR1,

    required this.midpointPPS1,
    required this.midpointS1S2,
    required this.midpointS2S3,
    required this.midpointS3S4,

    required this.indication,

    this.pivotType = 'Emas',
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);

  static const Color orangeColor = Color(0xFFF28C28);

  static const Color darkBrown = Color(0xFF3D2B1F);

  static const Color greenColor = Color(0xFF2E8B57);

  static const Color lightGreen = Color(0xFFE8F7EC);

  static const Color redColor = Color(0xFFD9534F);

  static const Color lightRed = Color(0xFFFCEAEA);

  static const Color lightOrange = Color(0xFFFFE5CC);

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bool isHangSeng = pivotType == 'Hang Seng';

    final String resultTitle = isHangSeng
        ? 'Hasil Pivot Hang Seng'
        : 'Hasil Pivot Point Emas';

    final String resultDescription = isHangSeng
        ? 'Berikut hasil perhitungan Pivot Point Hang Seng '
              'berdasarkan data yang Anda masukkan.'
        : 'Berikut hasil perhitungan Pivot Point Emas '
              'berdasarkan data yang Anda masukkan.';

    return Scaffold(
      backgroundColor: backgroundColor,

      // ==========================================================
      // APP BAR
      // ==========================================================
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

        title: Text(
          resultTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: orangeColor,
          ),
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // TITLE
              // ==================================================
              Text(
                'Rincian Perhitungan',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                resultDescription,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777777),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // DATA INPUT
              // ==================================================
              _buildSectionTitle('Data Input'),

              const SizedBox(height: 12),

              _buildInputCard(),

              const SizedBox(height: 20),

              // ==================================================
              // HASIL PIVOT POINT
              // ==================================================
              _buildSectionTitle('Hasil Pivot Point'),
              const SizedBox(height: 12),

              _buildPivotLevelsCard(),

              const SizedBox(height: 20),

              // ==================================================
              // RESISTANCE
              // ==================================================
              const SizedBox(height: 20),

              // ==================================================
              // INDIKASI
              // ==================================================
              _buildIndicationCard(),

              const SizedBox(height: 12),

              // ==================================================
              // HITUNG LAGI
              // ==================================================
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

              const SizedBox(height: 8),

              // ==================================================
              // UNDUH HASIL
              // ==================================================
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

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title, {Color color = darkBrown}) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
    );
  }

  // ============================================================
  // INPUT CARD
  // ============================================================

  Widget _buildInputCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Stack(
        children: [
          // ======================================================
          // LOGO EWF SEBAGAI WATERMARK
          // ======================================================
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.10,

                child: Image.asset(
                  'assets/images/ewf-logo.png',
                  width: 125,
                  height: 95,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // ======================================================
          // DATA INPUT
          // ======================================================
          Column(
            children: [
              _buildInputRow(
                icon: Icons.radio_button_checked_rounded,
                title: 'Open',
                value: open,
              ),

              const Divider(height: 20),

              _buildInputRow(
                icon: Icons.arrow_upward_rounded,
                title: 'High',
                value: high,
              ),

              const Divider(height: 20),

              _buildInputRow(
                icon: Icons.arrow_downward_rounded,
                title: 'Low',
                value: low,
              ),

              const Divider(height: 20),

              _buildInputRow(
                icon: Icons.show_chart_rounded,
                title: 'Close',
                value: close,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INPUT ROW
  // ============================================================

  Widget _buildInputRow({
    required IconData icon,
    required String title,
    required double value,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: lightOrange,
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon, color: orangeColor, size: 22),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF777777)),
          ),
        ),

        Text(
          _formatNumber(value),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: darkBrown,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PIVOT LEVELS CARD
  // ============================================================

  Widget _buildPivotLevelsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          _buildPivotLevelRow(
            level: 'R4',
            formula: 'PP + (High - Low) × 3',
            value: r4,
            color: greenColor,
            midpoint: midpointR4R3,
            midpointFormula: '(Hasil R4 + Hasil R3) / 2',
          ),

          _buildPivotLevelRow(
            level: 'R3',
            formula: 'PP + (High - Low) × 2',
            value: r3,
            color: greenColor,
            midpoint: midpointR3R2,
            midpointFormula: '(Hasil R3 + Hasil R2) / 2',
          ),

          _buildPivotLevelRow(
            level: 'R2',
            formula: 'PP + (High - Low)',
            value: r2,
            color: greenColor,
            midpoint: midpointR2R1,
            midpointFormula: '(Hasil R2 + Hasil R1) / 2',
          ),

          _buildPivotLevelRow(
            level: 'R1',
            formula: '2 × PP - Low',
            value: r1,
            color: greenColor,
            midpoint: midpointPPR1,
            midpointFormula: '(Hasil PP + Hasil R1) / 2',
          ),

          _buildPivotLevelRow(
            level: 'PP',
            formula: '(High + Low + Close) / 3',
            value: pp,
            color: orangeColor,
            midpoint: midpointPPS1,
            midpointFormula: '(Hasil PP + Hasil S1) / 2',
          ),

          _buildPivotLevelRow(
            level: 'S1',
            formula: '2 × PP - High',
            value: s1,
            color: redColor,
            midpoint: midpointS1S2,
            midpointFormula: '(Hasil S1 + Hasil S2) / 2',
          ),

          _buildPivotLevelRow(
            level: 'S2',
            formula: 'PP - (High - Low)',
            value: s2,
            color: redColor,
            midpoint: midpointS2S3,
            midpointFormula: '(Hasil S2 + Hasil S3) / 2',
          ),

          _buildPivotLevelRow(
            level: 'S3',
            formula: 'PP - (High - Low) × 2',
            value: s3,
            color: redColor,
            midpoint: midpointS3S4,
            midpointFormula: '(Hasil S3 + Hasil S4) / 2',
          ),

          _buildPivotLevelRow(
            level: 'S4',
            formula: 'PP - (High - Low) × 3',
            value: s4,
            color: redColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPivotLevelRow({
    required String level,
    required String formula,
    required double value,
    required Color color,
    double? midpoint,
    String? midpointFormula,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Text(
              level,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formula,
                  style: const TextStyle(fontSize: 15, color: darkBrown),
                ),

                if (midpoint != null && midpointFormula != null) ...[
                  const SizedBox(height: 7),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'midpoint',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          midpointFormula,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        _formatNumber(midpoint),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 10),

          Text(
            _formatNumber(value),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PIVOT CARD
  // ============================================================

  Widget _buildPivotCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFFFEAD6),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: orangeColor, width: 1.5),

        boxShadow: [
          BoxShadow(
            color: orangeColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: orangeColor,
              borderRadius: BorderRadius.circular(11),
            ),

            child: const Icon(
              Icons.show_chart_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Pivot Point (PP) $pivotType',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  'PP = (High + Low + Close) / 3',
                  style: TextStyle(fontSize: 10, color: Color(0xFF777777)),
                ),

                const SizedBox(height: 3),

                Text(
                  _formatNumber(pp),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: orangeColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RESISTANCE BLOCK
  // ============================================================

  Widget _buildResistanceBlock({
    required String level,
    required double value,
    required String formula,
    required String midpointText,
    required double midpoint,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border(
          left: BorderSide(color: greenColor, width: 3),
          top: const BorderSide(color: Color(0xFFE5E5E5), width: 0.7),
          bottom: const BorderSide(color: Color(0xFFE5E5E5), width: 0.7),
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ======================================================
          // LEVEL
          // ======================================================
          SizedBox(
            width: 38,

            child: Text(
              level,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: greenColor,
              ),
            ),
          ),

          const SizedBox(width: 6),

          // ======================================================
          // FORMULA + MIDPOINT
          // ======================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  formula,
                  style: const TextStyle(fontSize: 11, color: darkBrown),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    const Text(
                      'midpoint',
                      style: TextStyle(fontSize: 9.5, color: Color(0xFF999999)),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        midpointText.replaceFirst('Midpoint = ', ''),
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF999999),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // ======================================================
          // NILAI
          // ======================================================
          Text(
            _formatNumber(value),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: greenColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUPPORT BLOCK
  // ============================================================

  Widget _buildSupportBlock({
    required String level,
    required double value,
    required String formula,
    required String midpointText,
    required double midpoint,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border(
          left: BorderSide(color: redColor, width: 3),
          top: const BorderSide(color: Color(0xFFE5E5E5), width: 0.7),
          bottom: const BorderSide(color: Color(0xFFE5E5E5), width: 0.7),
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ======================================================
          // LEVEL
          // ======================================================
          SizedBox(
            width: 38,

            child: Text(
              level,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: redColor,
              ),
            ),
          ),

          const SizedBox(width: 6),

          // ======================================================
          // FORMULA + MIDPOINT
          // ======================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  formula,
                  style: const TextStyle(fontSize: 11, color: darkBrown),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    const Text(
                      'midpoint',
                      style: TextStyle(fontSize: 9.5, color: Color(0xFF999999)),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        midpointText.replaceFirst('Midpoint = ', ''),
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF999999),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // ======================================================
          // NILAI
          // ======================================================
          Text(
            _formatNumber(value),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: redColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MIDPOINT CARD
  // ============================================================

  Widget _buildMidpointCard({
    required String text,
    required double value,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),

      decoration: BoxDecoration(
        color: backgroundColor,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: color.withOpacity(0.18)),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(Icons.compare_arrows_rounded, size: 19, color: color),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'MIDPOINT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 0.7,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF777777),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            _formatNumber(value),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INDIKASI CARD
  // ============================================================

  Widget _buildIndicationCard() {
    final bool isBuy = indication == 'BUY';

    final Color indicationColor = isBuy ? greenColor : redColor;

    final Color indicationBackground = isBuy ? lightGreen : lightRed;

    final bool isHangSeng = pivotType == 'Hang Seng';

    final String indicationDescription;

    if (isHangSeng) {
      indicationDescription = isBuy
          ? 'Open berada di atas Pivot Point Hang Seng.'
          : 'Open berada di bawah Pivot Point Hang Seng.';
    } else {
      indicationDescription = isBuy
          ? 'Open berada di bawah Pivot Point Emas.'
          : 'Open berada di atas Pivot Point Emas.';
    }

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: indicationColor.withOpacity(0.25)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'INDIKASI',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: darkBrown,
              letterSpacing: 0.8,
            ),
          ),

          const SizedBox(height: 2),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: indicationBackground,
              borderRadius: BorderRadius.circular(15),
            ),

            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,

                  decoration: BoxDecoration(
                    color: indicationColor,
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    isBuy
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        indication,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: indicationColor,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        indicationDescription,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Open: ${_formatNumber(open)}  •  '
            'Pivot Point: ${_formatNumber(pp)}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DOWNLOAD PDF
  // ============================================================

  Future<void> _downloadResult(BuildContext context) async {
    try {
      final Uint8List pdfBytes = await _generatePdf();

      String downloadPath;

      if (Platform.isAndroid) {
        downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOAD,
        );
      } else {
        downloadPath = '.';
      }

      final String fileName =
          'hasil_pivot_${pivotType.toLowerCase().replaceAll(' ', '_')}_'
          '${DateTime.now().millisecondsSinceEpoch}.pdf';

      final String filePath = '$downloadPath/$fileName';

      final File file = File(filePath);

      await file.writeAsBytes(pdfBytes);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Hasil Pivot Point berhasil diunduh ke folder Download.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          backgroundColor: darkBrown,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengunduh hasil PDF: $e',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          backgroundColor: redColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // ============================================================
  // GENERATE PDF
  // ============================================================

  Future<Uint8List> _generatePdf() async {
    final pw.Document pdf = pw.Document();

    final pw.MemoryImage? logoImage = await _loadLogo();

    final PdfColor orangePdf = PdfColor.fromHex('#F28C28');
    final PdfColor darkBrownPdf = PdfColor.fromHex('#3D2B1F');
    final PdfColor greenPdf = PdfColor.fromHex('#2E8B57');
    final PdfColor redPdf = PdfColor.fromHex('#D9534F');
    final PdfColor greyPdf = PdfColor.fromHex('#777777');
    final PdfColor lightOrangePdf = PdfColor.fromHex('#FFE5CC');
    final PdfColor lightGreenPdf = PdfColor.fromHex('#E8F7EC');
    final PdfColor lightRedPdf = PdfColor.fromHex('#FCEAEA');

    final bool isHangSeng = pivotType == 'Hang Seng';

    final String pdfTitle = isHangSeng
        ? 'Hasil Pivot Hang Seng'
        : 'Hasil Pivot Point Emas';

    final String pdfDescription = isHangSeng
        ? 'Rincian hasil perhitungan Pivot Point Hang Seng'
        : 'Rincian hasil perhitungan Pivot Point Emas';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),

        header: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'AURUM',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: orangePdf,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        pdfTitle,
                        style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: darkBrownPdf,
                        ),
                      ),
                    ],
                  ),

                  if (logoImage != null)
                    pw.Opacity(
                      opacity: 0.85,
                      child: pw.Image(
                        logoImage,
                        width: 78,
                        height: 55,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                ],
              ),

              pw.SizedBox(height: 8),

              pw.Divider(color: PdfColor.fromHex('#E5E5E5'), thickness: 1),

              pw.SizedBox(height: 4),
            ],
          );
        },

        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(color: PdfColor.fromHex('#E5E5E5'), thickness: 0.7),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'AURUM - Pivot Point Calculator',
                    style: pw.TextStyle(fontSize: 8, color: greyPdf),
                  ),
                  pw.Text(
                    'Halaman ${context.pageNumber}',
                    style: pw.TextStyle(fontSize: 8, color: greyPdf),
                  ),
                ],
              ),
            ],
          );
        },

        build: (pw.Context context) {
          return [
            pw.Text(
              pdfDescription,
              style: pw.TextStyle(fontSize: 10, color: greyPdf),
            ),

            pw.SizedBox(height: 15),

            // ==================================================
            // DATA INPUT
            // ==================================================
            _buildPdfSectionTitle('DATA INPUT', darkBrownPdf),

            pw.SizedBox(height: 8),

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                border: pw.Border.all(
                  color: PdfColor.fromHex('#E5E5E5'),
                  width: 0.8,
                ),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                children: [
                  _buildPdfDataRow('Open', _formatNumber(open), darkBrownPdf),
                  _buildPdfDivider(),
                  _buildPdfDataRow('High', _formatNumber(high), darkBrownPdf),
                  _buildPdfDivider(),
                  _buildPdfDataRow('Low', _formatNumber(low), darkBrownPdf),
                  _buildPdfDivider(),
                  _buildPdfDataRow('Close', _formatNumber(close), darkBrownPdf),
                ],
              ),
            ),

            pw.SizedBox(height: 16),

            // ==================================================
            // PIVOT POINT UTAMA
            // ==================================================
            _buildPdfSectionTitle('PIVOT POINT UTAMA', orangePdf),

            pw.SizedBox(height: 8),

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#FFEDD9'),
                border: pw.Border.all(color: orangePdf, width: 1),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Pivot Point (PP) $pivotType',
                    style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                      color: darkBrownPdf,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'PP = (High + Low + Close) / 3',
                    style: pw.TextStyle(fontSize: 9, color: greyPdf),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    _formatNumber(pp),
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: orangePdf,
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 16),

            // ==================================================
            // RESISTANCE
            // ==================================================
            _buildPdfSectionTitle('RESISTANCE (ATAS)', greenPdf),

            pw.SizedBox(height: 8),

            _buildPdfLevelRow(
              level: 'R4',
              value: r4,
              formula: 'PP + (High - Low) × 3',
              midpointLabel: 'Midpoint R4-R3',
              midpoint: midpointR4R3,
              valueColor: greenPdf,
              backgroundColor: lightGreenPdf,
            ),

            pw.SizedBox(height: 7),

            _buildPdfLevelRow(
              level: 'R3',
              value: r3,
              formula: 'PP + (High - Low) × 2',
              midpointLabel: 'Midpoint R3-R2',
              midpoint: midpointR3R2,
              valueColor: greenPdf,
              backgroundColor: lightGreenPdf,
            ),

            pw.SizedBox(height: 7),

            _buildPdfLevelRow(
              level: 'R2',
              value: r2,
              formula: 'PP + (High - Low)',
              midpointLabel: 'Midpoint R2-R1',
              midpoint: midpointR2R1,
              valueColor: greenPdf,
              backgroundColor: lightGreenPdf,
            ),

            pw.SizedBox(height: 7),

            _buildPdfLevelRow(
              level: 'R1',
              value: r1,
              formula: '2 × PP - Low',
              midpointLabel: 'Midpoint PP-R1',
              midpoint: midpointPPR1,
              valueColor: greenPdf,
              backgroundColor: lightGreenPdf,
            ),

            pw.SizedBox(height: 16),

            // ==================================================
            // SUPPORT
            // ==================================================
            _buildPdfSectionTitle('SUPPORT (BAWAH)', redPdf),

            pw.SizedBox(height: 8),

            _buildPdfLevelRow(
              level: 'S1',
              value: s1,
              formula: '2 × PP - High',
              midpointLabel: 'Midpoint PP-S1',
              midpoint: midpointPPS1,
              valueColor: redPdf,
              backgroundColor: lightRedPdf,
            ),

            pw.SizedBox(height: 7),

            _buildPdfLevelRow(
              level: 'S2',
              value: s2,
              formula: 'PP - (High - Low)',
              midpointLabel: 'Midpoint S1-S2',
              midpoint: midpointS1S2,
              valueColor: redPdf,
              backgroundColor: lightRedPdf,
            ),

            pw.SizedBox(height: 7),

            _buildPdfLevelRow(
              level: 'S3',
              value: s3,
              formula: 'PP - (High - Low) × 2',
              midpointLabel: 'Midpoint S2-S3',
              midpoint: midpointS2S3,
              valueColor: redPdf,
              backgroundColor: lightRedPdf,
            ),

            pw.SizedBox(height: 7),

            _buildPdfLevelRow(
              level: 'S4',
              value: s4,
              formula: 'PP - (High - Low) × 3',
              midpointLabel: 'Midpoint S3-S4',
              midpoint: midpointS3S4,
              valueColor: redPdf,
              backgroundColor: lightRedPdf,
            ),

            pw.SizedBox(height: 16),

            // ==================================================
            // INDIKASI
            // ==================================================
            _buildPdfSectionTitle('INDIKASI', darkBrownPdf),

            pw.SizedBox(height: 8),

            _buildPdfIndicationCard(
              isBuy: indication == 'BUY',
              indicationValue: indication,
              indicationColor: indication == 'BUY' ? greenPdf : redPdf,
              indicationBackground: indication == 'BUY'
                  ? lightGreenPdf
                  : lightRedPdf,
              indicationDescription: isHangSeng
                  ? (indication == 'BUY'
                        ? 'Open berada di atas Pivot Point Hang Seng.'
                        : 'Open berada di bawah Pivot Point Hang Seng.')
                  : (indication == 'BUY'
                        ? 'Open berada di bawah Pivot Point Emas.'
                        : 'Open berada di atas Pivot Point Emas.'),
              greyColor: greyPdf,
              darkBrownColor: darkBrownPdf,
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // LOAD LOGO
  // ============================================================

  Future<pw.MemoryImage?> _loadLogo() async {
    try {
      final ByteData data = await rootBundle.load('assets/images/ewf-logo.png');

      return pw.MemoryImage(data.buffer.asUint8List());
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // PDF SECTION TITLE
  // ============================================================

  pw.Widget _buildPdfSectionTitle(String title, PdfColor color) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 11,
        fontWeight: pw.FontWeight.bold,
        color: color,
        letterSpacing: 0.5,
      ),
    );
  }

  // ============================================================
  // PDF DATA ROW
  // ============================================================

  pw.Widget _buildPdfDataRow(String title, String value, PdfColor color) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 10, color: PdfColor.fromHex('#777777')),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PDF DIVIDER
  // ============================================================

  pw.Widget _buildPdfDivider() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Divider(color: PdfColor.fromHex('#EEEEEE'), thickness: 0.6),
    );
  }

  // ============================================================
  // PDF LEVEL ROW
  // ============================================================

  pw.Widget _buildPdfLevelRow({
    required String level,
    required double value,
    required String formula,
    required String midpointLabel,
    required double midpoint,
    required PdfColor valueColor,
    required PdfColor backgroundColor,
  }) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: PdfColor.fromHex('#E5E5E5'), width: 0.7),
        borderRadius: pw.BorderRadius.circular(7),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 34,
                height: 28,
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(
                  color: backgroundColor,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Text(
                  level,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ),

              pw.SizedBox(width: 9),

              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      level,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                        color: valueColor,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      _formatNumber(value),
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#3D2B1F'),
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      formula,
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColor.fromHex('#777777'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 7),

          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: pw.BoxDecoration(
              color: backgroundColor,
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  midpointLabel,
                  style: pw.TextStyle(fontSize: 8, color: valueColor),
                ),
                pw.Text(
                  _formatNumber(midpoint),
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PDF INDIKASI CARD
  // ============================================================

  pw.Widget _buildPdfIndicationCard({
    required bool isBuy,
    required String indicationValue,
    required PdfColor indicationColor,
    required PdfColor indicationBackground,
    required String indicationDescription,
    required PdfColor greyColor,
    required PdfColor darkBrownColor,
  }) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: indicationColor, width: 0.8),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: indicationBackground,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Row(
              children: [
                pw.Container(
                  width: 30,
                  height: 30,
                  alignment: pw.Alignment.center,
                  decoration: pw.BoxDecoration(
                    color: indicationColor,
                    shape: pw.BoxShape.circle,
                  ),
                  child: pw.Text(
                    isBuy ? '↑' : '↓',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                ),

                pw.SizedBox(width: 9),

                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        indicationValue,
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                          color: indicationColor,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        indicationDescription,
                        style: pw.TextStyle(fontSize: 9, color: greyColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 8),

          pw.Text(
            'Open: ${_formatNumber(open)}    '
            'Pivot Point: ${_formatNumber(pp)}',
            style: pw.TextStyle(fontSize: 9, color: greyColor),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showSavedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Hasil Pivot Point berhasil disimpan ke riwayat.',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        backgroundColor: darkBrown,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // FORMAT ANGKA
  // ============================================================

  String _formatNumber(double value) {
    return value.toStringAsFixed(2);
  }
}
