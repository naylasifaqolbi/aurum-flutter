import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // HEADER
              // ==================================================
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 42,
                    height: 42,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    'AURUM',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: orangeColor,
                      letterSpacing: 1,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},

                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 28,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ==================================================
              // TITLE
              // ==================================================
              const Text(
                'Rincian Perhitungan',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Berikut hasil perhitungan Pivot Point '
                'berdasarkan data yang Anda masukkan.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777777),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // DATA INPUT
              // ==================================================
              _buildSectionTitle('Data Input'),

              const SizedBox(height: 12),

              _buildInputCard(),

              const SizedBox(height: 30),

              // ==================================================
              // HASIL PIVOT POINT
              // ==================================================
              _buildSectionTitle('Hasil Pivot Point'),

              const SizedBox(height: 15),

              // ==================================================
              // RESISTANCE
              // ==================================================
              _buildSectionTitle('Resistance (Atas)', color: greenColor),

              const SizedBox(height: 15),

              // R4
              _buildResistanceBlock(
                level: 'R4',
                value: r4,
                formula: 'PP + (High - Low) × 3',
                midpointText: 'Midpoint = (Hasil R4 + Hasil R3) / 2',
                midpoint: midpointR4R3,
              ),

              const SizedBox(height: 14),

              // R3
              _buildResistanceBlock(
                level: 'R3',
                value: r3,
                formula: 'PP + (High - Low) × 2',
                midpointText: 'Midpoint = (Hasil R3 + Hasil R2) / 2',
                midpoint: midpointR3R2,
              ),

              const SizedBox(height: 14),

              // R2
              _buildResistanceBlock(
                level: 'R2',
                value: r2,
                formula: 'PP + (High - Low)',
                midpointText: 'Midpoint = (Hasil R2 + Hasil R1) / 2',
                midpoint: midpointR2R1,
              ),

              const SizedBox(height: 14),

              // R1
              _buildResistanceBlock(
                level: 'R1',
                value: r1,
                formula: '2 × PP - High',
                midpointText: 'Midpoint = (Hasil PP + Hasil R1) / 2',
                midpoint: midpointPPR1,
              ),

              const SizedBox(height: 25),

              // ==================================================
              // PIVOT POINT UTAMA
              // ==================================================
              _buildPivotCard(),

              const SizedBox(height: 25),

              // ==================================================
              // SUPPORT
              // ==================================================
              _buildSectionTitle('Support (Bawah)', color: redColor),

              const SizedBox(height: 15),

              // S1
              _buildSupportBlock(
                level: 'S1',
                value: s1,
                formula: '2 × PP - High',
                midpointText: 'Midpoint = (Hasil PP + Hasil S1) / 2',
                midpoint: midpointPPS1,
              ),

              const SizedBox(height: 14),

              // S2
              _buildSupportBlock(
                level: 'S2',
                value: s2,
                formula: 'PP - (High - Low)',
                midpointText: 'Midpoint = (Hasil S1 + Hasil S2) / 2',
                midpoint: midpointS1S2,
              ),

              const SizedBox(height: 14),

              // S3
              _buildSupportBlock(
                level: 'S3',
                value: s3,
                formula: 'PP - (High - Low) × 2',
                midpointText: 'Midpoint = (Hasil S2 + Hasil S3) / 2',
                midpoint: midpointS2S3,
              ),

              const SizedBox(height: 14),

              // S4
              _buildSupportBlock(
                level: 'S4',
                value: s4,
                formula: 'PP - (High - Low) × 3',
                midpointText: 'Midpoint = (Hasil S3 + Hasil S4) / 2',
                midpoint: midpointS3S4,
              ),

              const SizedBox(height: 30),

              // ==================================================
              // INDIKASI
              // ==================================================
              _buildIndicationCard(),

              const SizedBox(height: 25),

              // ==================================================
              // HITUNG LAGI
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 52,

                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(Icons.refresh_rounded),

                  label: const Text(
                    'Hitung Lagi',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  style: OutlinedButton.styleFrom(
                    foregroundColor: orangeColor,

                    side: const BorderSide(color: orangeColor, width: 1.5),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ==================================================
              // SIMPAN KE RIWAYAT
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton.icon(
                  onPressed: () {
                    _showSavedMessage(context);
                  },

                  icon: const Icon(Icons.bookmark_border_rounded),

                  label: const Text(
                    'Simpan ke Riwayat',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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
        children: [
          _buildInputRow(
            icon: Icons.radio_button_checked_rounded,
            title: 'Open',
            value: open,
          ),

          const Divider(height: 24),

          _buildInputRow(
            icon: Icons.arrow_upward_rounded,
            title: 'High',
            value: high,
          ),

          const Divider(height: 24),

          _buildInputRow(
            icon: Icons.arrow_downward_rounded,
            title: 'Low',
            value: low,
          ),

          const Divider(height: 24),

          _buildInputRow(
            icon: Icons.show_chart_rounded,
            title: 'Close',
            value: close,
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
  // PIVOT CARD
  // ============================================================

  Widget _buildPivotCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFFFFEAD6),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: orangeColor, width: 1.5),

        boxShadow: [
          BoxShadow(
            color: orangeColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: orangeColor,
                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.show_chart_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Text(
                  'Pivot Point (PP)',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Text(
            'PP = (High + Low + Close) / 3',
            style: TextStyle(fontSize: 13, color: Color(0xFF777777)),
          ),

          const SizedBox(height: 8),

          Text(
            _formatNumber(pp),

            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: orangeColor,
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
    return Column(
      children: [
        // ========================================================
        // R CARD
        // ========================================================
        Container(
          width: double.infinity,

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(18),

            border: Border.all(color: const Color(0xFFBFE5CD), width: 1),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(14),
                ),

                alignment: Alignment.center,

                child: Text(
                  level,

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: greenColor,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      level,

                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: greenColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _formatNumber(value),

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      formula,

                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF777777),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ========================================================
        // MIDPOINT DI BAWAH R
        // ========================================================
        _buildMidpointCard(
          text: midpointText,
          value: midpoint,
          color: greenColor,
          backgroundColor: lightGreen,
        ),
      ],
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
    return Column(
      children: [
        // ========================================================
        // MIDPOINT DI ATAS S
        // ========================================================
        _buildMidpointCard(
          text: midpointText,
          value: midpoint,
          color: redColor,
          backgroundColor: lightRed,
        ),

        const SizedBox(height: 8),

        // ========================================================
        // S CARD
        // ========================================================
        Container(
          width: double.infinity,

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(18),

            border: Border.all(color: const Color(0xFFF2C4C2), width: 1),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: lightRed,
                  borderRadius: BorderRadius.circular(14),
                ),

                alignment: Alignment.center,

                child: Text(
                  level,

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: redColor,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      level,

                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: redColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _formatNumber(value),

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      formula,

                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF777777),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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

          const SizedBox(height: 14),

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
                        isBuy
                            ? 'Open berada di bawah Pivot Point.'
                            : 'Open berada di atas Pivot Point.',

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
