import 'package:flutter/material.dart';

import '../../models/history_model.dart';

class PivotHistoryDetail extends StatelessWidget {
  final HistoryModel history;

  const PivotHistoryDetail({super.key, required this.history});

  // ============================================================
  // COLOR
  // ============================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color orangeColor = Color(0xFFF28C28);
  static const Color darkBrown = Color(0xFF3D2B1F);

  static const Color greenColor = Color(0xFF2E8B57);
  static const Color redColor = Color(0xFFD9534F);

  @override
  Widget build(BuildContext context) {
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

      // ============================================================
      // BODY
      // ============================================================
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
                          Icons.show_chart_rounded,
                          color: orangeColor,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'KALKULATOR PP EMAS',
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
              // SUMMARY + MARKET INPUT
              // ==================================================
              _buildSummaryCard(
                pp: pp,
                indication: indication,
                open: open,
                high: high,
                low: low,
                close: close,
              ),

              const SizedBox(height: 18),

              // ==================================================
              // PIVOT LEVEL
              // ==================================================
              _buildPivotLevelsCard(
                pp: pp,
                r1: r1,
                r2: r2,
                r3: r3,
                r4: r4,
                s1: s1,
                s2: s2,
                s3: s3,
                s4: s4,
                midpointR4R3: midpointR4R3,
                midpointR3R2: midpointR3R2,
                midpointR2R1: midpointR2R1,
                midpointPPR1: midpointPPR1,
                midpointPPS1: midpointPPS1,
                midpointS1S2: midpointS1S2,
                midpointS2S3: midpointS2S3,
                midpointS3S4: midpointS3S4,
              ),

              const SizedBox(height: 20),

              // ==================================================
              // DOWNLOAD BUTTON
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Fitur download akan disambungkan nanti.
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
                  onPressed: () {
                    // Fitur hapus akan disambungkan ke database nanti.
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
  // SUMMARY CARD
  // ============================================================

  Widget _buildSummaryCard({
    required double pp,
    required String indication,
    required double open,
    required double high,
    required double low,
    required double close,
  }) {
    final bool isBuy = indication == 'BUY';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
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
              // TITLE
              // ==================================================
              const Text(
                'Ringkasan Pivot Point',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF667085),
                ),
              ),

              const SizedBox(height: 8),

              // ==================================================
              // PP VALUE
              // ==================================================
              Center(
                child: Column(
                  children: [
                    const Text(
                      'PIVOT POINT (PP)',
                      style: TextStyle(fontSize: 10, color: Color(0xFF8A94A6)),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      pp.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: orangeColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 7),

              // ==================================================
              // INDICATION
              // ==================================================
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (isBuy ? greenColor : redColor).withValues(
                      alpha: 0.10,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'INDIKASI ${isBuy ? 'BUY ↑' : 'SELL ↓'}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isBuy ? greenColor : redColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Divider(height: 1, color: Color(0xFFECEFF3)),

              const SizedBox(height: 12),

              // ==================================================
              // MARKET INPUT TITLE
              // ==================================================
              const Text(
                'DATA PASAR INPUT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF667085),
                ),
              ),

              const SizedBox(height: 8),

              // ==================================================
              // MARKET INPUT
              // ==================================================
              Row(
                children: [
                  Expanded(
                    child: _buildInputBox(
                      label: 'Open',
                      value: open.toStringAsFixed(2),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _buildInputBox(
                      label: 'High',
                      value: high.toStringAsFixed(2),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              Row(
                children: [
                  Expanded(
                    child: _buildInputBox(
                      label: 'Low',
                      value: low.toStringAsFixed(2),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _buildInputBox(
                      label: 'Close',
                      value: close.toStringAsFixed(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INPUT BOX
  // ============================================================

  Widget _buildInputBox({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDDE2E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF667085)),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PIVOT LEVELS
  // ============================================================

  Widget _buildPivotLevelsCard({
    required double pp,
    required double r1,
    required double r2,
    required double r3,
    required double r4,
    required double s1,
    required double s2,
    required double s3,
    required double s4,
    required double midpointR4R3,
    required double midpointR3R2,
    required double midpointR2R1,
    required double midpointPPR1,
    required double midpointPPS1,
    required double midpointS1S2,
    required double midpointS2S3,
    required double midpointS3S4,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE1E7EF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================================
          // TITLE
          // ==================================================
          const Text(
            'Hasil Pivot Point',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 12),

          // ==================================================
          // TABLE HEADER
          // ==================================================
          const Row(
            children: [
              SizedBox(
                width: 38,
                child: Text(
                  'LEVEL',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF98A2B3),
                  ),
                ),
              ),

              SizedBox(width: 6),

              Expanded(
                child: Text(
                  'FORMULA',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF98A2B3),
                  ),
                ),
              ),

              Text(
                'NILAI',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF98A2B3),
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // ==================================================
          // RESISTANCE
          // ==================================================
          _buildPivotRow(
            level: 'R4',
            formula: 'PP + (H - L) × 3',
            value: r4.toStringAsFixed(2),
            color: greenColor,
            midpoint: '(R4 + R3) / 2',
            midpointValue: midpointR4R3.toStringAsFixed(2),
          ),

          _buildPivotRow(
            level: 'R3',
            formula: 'PP + (H - L) × 2',
            value: r3.toStringAsFixed(2),
            color: greenColor,
            midpoint: '(R3 + R2) / 2',
            midpointValue: midpointR3R2.toStringAsFixed(2),
          ),

          _buildPivotRow(
            level: 'R2',
            formula: 'PP + (H - L)',
            value: r2.toStringAsFixed(2),
            color: greenColor,
            midpoint: '(R2 + R1) / 2',
            midpointValue: midpointR2R1.toStringAsFixed(2),
          ),

          _buildPivotRow(
            level: 'R1',
            formula: '2 × PP - L',
            value: r1.toStringAsFixed(2),
            color: greenColor,
            midpoint: '(PP + R1) / 2',
            midpointValue: midpointPPR1.toStringAsFixed(2),
          ),

          // ==================================================
          // PIVOT POINT
          // ==================================================
          _buildPivotRow(
            level: 'PP',
            formula: '(H + L + C) / 3',
            value: pp.toStringAsFixed(2),
            color: orangeColor,
            midpoint: '(PP + S1) / 2',
            midpointValue: midpointPPS1.toStringAsFixed(2),
            isMainPivot: true,
          ),

          // ==================================================
          // SUPPORT
          // ==================================================
          _buildPivotRow(
            level: 'S1',
            formula: '2 × PP - H',
            value: s1.toStringAsFixed(2),
            color: redColor,
            midpoint: '(S1 + S2) / 2',
            midpointValue: midpointS1S2.toStringAsFixed(2),
          ),

          _buildPivotRow(
            level: 'S2',
            formula: 'PP - (H - L)',
            value: s2.toStringAsFixed(2),
            color: redColor,
            midpoint: '(S2 + S3) / 2',
            midpointValue: midpointS2S3.toStringAsFixed(2),
          ),

          _buildPivotRow(
            level: 'S3',
            formula: 'PP - (H - L) × 2',
            value: s3.toStringAsFixed(2),
            color: redColor,
            midpoint: '(S3 + S4) / 2',
            midpointValue: midpointS3S4.toStringAsFixed(2),
          ),

          _buildPivotRow(
            level: 'S4',
            formula: 'PP - (H - L) × 3',
            value: s4.toStringAsFixed(2),
            color: redColor,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PIVOT ROW
  // ============================================================

  Widget _buildPivotRow({
    required String level,
    required String formula,
    required String value,
    required Color color,
    String? midpoint,
    String? midpointValue,
    bool isMainPivot = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          // ==================================================
          // LEVEL / FORMULA / NILAI
          // ==================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isMainPivot ? const Color(0xFFFFF2D2) : Colors.white,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: isMainPivot
                    ? const Color(0xFFFFD27A)
                    : const Color(0xFFE1E7EF),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ==================================================
                // LEVEL
                // ==================================================
                SizedBox(
                  width: 38,
                  child: Text(
                    level,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                // ==================================================
                // FORMULA
                // ==================================================
                Expanded(
                  child: Text(
                    formula,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isMainPivot
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isMainPivot ? darkBrown : const Color(0xFF667085),
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                // ==================================================
                // NILAI
                // ==================================================
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // MIDPOINT CARD
          // ==================================================
          if (midpoint != null && midpointValue != null) ...[
            const SizedBox(height: 3),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: const Color(0xFFE1E7EF), width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ==================================================
                  // SPASI LEVEL
                  // ==================================================
                  const SizedBox(width: 38),

                  const SizedBox(width: 6),

                  // ==================================================
                  // MIDPOINT FORMULA
                  // ==================================================
                  Expanded(
                    child: Text(
                      'Midpoint $midpoint',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF98A2B3),
                      ),
                    ),
                  ),

                  const SizedBox(width: 6),

                  // ==================================================
                  // MIDPOINT VALUE
                  // ==================================================
                  Text(
                    midpointValue,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF888F9A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
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
