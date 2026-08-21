import 'package:flutter/material.dart';

class PivotResult extends StatelessWidget {
  final double high;
  final double low;
  final double close;

  final double pp;

  final double r1;
  final double r2;
  final double r3;
  final double r4;

  final double s1;
  final double s2;
  final double s3;
  final double s4;

  final double midpointR4R3;
  final double midpointR3R2;
  final double midpointR2R1;
  final double midpointPPR1;
  final double midpointPPS1;
  final double midpointS1S2;
  final double midpointS2S3;
  final double midpointS3S4;

  const PivotResult({
    super.key,
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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==========================================
              // HEADER
              // ==========================================
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
                      color: Color(0xFFF28C28),
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

              const SizedBox(height: 35),

              // ==========================================
              // TITLE
              // ==========================================
              const Text(
                'Hasil Pivot Point',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF28C28),
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

              // ==========================================
              // INPUT DATA
              // ==========================================
              _buildSectionTitle('Data Input'),

              const SizedBox(height: 12),

              _buildInputCard(),

              const SizedBox(height: 25),

              // ==========================================
              // PIVOT POINT
              // ==========================================
              _buildSectionTitle('Pivot Point'),

              const SizedBox(height: 12),

              _buildResultCard(
                title: 'PP',
                value: pp,
                icon: Icons.show_chart_rounded,
                highlight: true,
              ),

              const SizedBox(height: 25),

              // ==========================================
              // RESISTANCE
              // ==========================================
              _buildSectionTitle('Resistance'),

              const SizedBox(height: 12),

              _buildLevelCard(level: 'R4', value: r4, midpoint: midpointR4R3),

              const SizedBox(height: 12),

              _buildLevelCard(level: 'R3', value: r3, midpoint: midpointR3R2),

              const SizedBox(height: 12),

              _buildLevelCard(level: 'R2', value: r2, midpoint: midpointR2R1),

              const SizedBox(height: 12),

              _buildLevelCard(level: 'R1', value: r1, midpoint: midpointPPR1),

              const SizedBox(height: 25),

              // ==========================================
              // SUPPORT
              // ==========================================
              _buildSectionTitle('Support'),

              const SizedBox(height: 12),

              _buildLevelCard(level: 'S1', value: s1, midpoint: midpointPPS1),

              const SizedBox(height: 12),

              _buildLevelCard(level: 'S2', value: s2, midpoint: midpointS1S2),

              const SizedBox(height: 12),

              _buildLevelCard(level: 'S3', value: s3, midpoint: midpointS2S3),

              const SizedBox(height: 12),

              _buildLevelCard(level: 'S4', value: s4, midpoint: midpointS3S4),

              const SizedBox(height: 30),

              // ==========================================
              // BUTTON KEMBALI
              // ==========================================
              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(Icons.arrow_back_rounded),

                  label: const Text(
                    'Kembali ke Kalkulator',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF28C28),
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

  // ==================================================
  // SECTION TITLE
  // ==================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3D2B1F),
      ),
    );
  }

  // ==================================================
  // INPUT CARD
  // ==================================================

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
            icon: Icons.arrow_upward_rounded,
            title: 'Harga High',
            value: high,
          ),

          const Divider(height: 24),

          _buildInputRow(
            icon: Icons.arrow_downward_rounded,
            title: 'Harga Low',
            value: low,
          ),

          const Divider(height: 24),

          _buildInputRow(
            icon: Icons.show_chart_rounded,
            title: 'Harga Close',
            value: close,
          ),
        ],
      ),
    );
  }

  // ==================================================
  // INPUT ROW
  // ==================================================

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
            color: const Color(0xFFFFE5CC),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon, color: const Color(0xFFF28C28), size: 22),
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
            color: Color(0xFF3D2B1F),
          ),
        ),
      ],
    );
  }

  // ==================================================
  // RESULT CARD
  // ==================================================

  Widget _buildResultCard({
    required String title,
    required double value,
    required IconData icon,
    bool highlight = false,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: highlight
            ? Border.all(color: const Color(0xFFF28C28), width: 1.5)
            : null,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: const Color(0xFFFFE5CC),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: const Color(0xFFF28C28), size: 25),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF777777),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  _formatNumber(value),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D2B1F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // LEVEL CARD
  // ==================================================

  Widget _buildLevelCard({
    required String level,
    required double value,
    required double midpoint,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

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

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,

                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5CC),
                  borderRadius: BorderRadius.circular(13),
                ),

                alignment: Alignment.center,

                child: Text(
                  level,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF28C28),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Nilai Level',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _formatNumber(value),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D2B1F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),

            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F0),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Row(
              children: [
                const Icon(
                  Icons.compare_arrows_rounded,
                  size: 19,
                  color: Color(0xFFF28C28),
                ),

                const SizedBox(width: 8),

                const Expanded(
                  child: Text(
                    'Midpoint',
                    style: TextStyle(fontSize: 13, color: Color(0xFF777777)),
                  ),
                ),

                Text(
                  _formatNumber(midpoint),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D2B1F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // FORMAT ANGKA
  // ==================================================

  String _formatNumber(double value) {
    return value.toStringAsFixed(2);
  }
}
