import 'package:flutter/material.dart';

class PivotHistoryDetail extends StatelessWidget {
  const PivotHistoryDetail({super.key});

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
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // HEADER
              // ==================================================
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: darkBrown,
                      size: 21,
                    ),
                  ),

                  const SizedBox(width: 4),

                  const Text(
                    'Detail Riwayat',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  '24 Okt 2026, 09:15 WIB',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // TITLE
              // ==================================================
              const Text(
                'KALKULATOR PIVOT POINT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // SUMMARY
              // ==================================================
              _buildSummaryCard(),

              const SizedBox(height: 20),

              // ==================================================
              // MARKET INPUT
              // ==================================================
              _buildMarketInputCard(),

              const SizedBox(height: 20),

              // ==================================================
              // LEVEL PIVOT
              // ==================================================
              const Text(
                'Level Pivot Point',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 12),

              _buildPivotLevel(
                level: 'R4',
                formula: 'PP + (High - Low) x 3',
                value: '1996.80',
                color: greenColor,
              ),

              _buildMidpoint(formula: '(R4 + R3) / 2', value: '1993.20'),

              _buildPivotLevel(
                level: 'R3',
                formula: 'PP + (High - Low) x 2',
                value: '1989.60',
                color: greenColor,
              ),

              _buildMidpoint(formula: '(R3 + R2) / 2', value: '1987.20'),

              _buildPivotLevel(
                level: 'R2',
                formula: 'PP + (High - Low)',
                value: '1984.80',
                color: greenColor,
              ),

              _buildMidpoint(formula: '(R2 + R1) / 2', value: '1981.20'),

              _buildPivotLevel(
                level: 'R1',
                formula: '2 x PP - Low',
                value: '1977.60',
                color: greenColor,
              ),

              _buildMidpoint(formula: '(PP + R1) / 2', value: '1975.20'),

              // ==================================================
              // PP
              // ==================================================
              _buildPivotLevel(
                level: 'PP',
                formula: '(High + Low + Close) / 3',
                value: '1972.80',
                color: orangeColor,
                isMainPivot: true,
              ),

              _buildMidpoint(formula: '(PP + S1) / 2', value: '1969.20'),

              // ==================================================
              // SUPPORT
              // ==================================================
              _buildPivotLevel(
                level: 'S1',
                formula: '2 x PP - High',
                value: '1965.60',
                color: redColor,
              ),

              _buildMidpoint(formula: '(S1 + S2) / 2', value: '1963.20'),

              _buildPivotLevel(
                level: 'S2',
                formula: 'PP - (High - Low)',
                value: '1960.80',
                color: redColor,
              ),

              _buildMidpoint(formula: '(S2 + S3) / 2', value: '1957.20'),

              _buildPivotLevel(
                level: 'S3',
                formula: 'PP - (High - Low) x 2',
                value: '1953.60',
                color: redColor,
              ),

              _buildMidpoint(formula: '(S3 + S4) / 2', value: '1951.20'),

              _buildPivotLevel(
                level: 'S4',
                formula: 'PP - (High - Low) x 3',
                value: '1948.80',
                color: redColor,
              ),

              const SizedBox(height: 25),

              // ==================================================
              // FOOTER
              // ==================================================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(color: const Color(0xFFFFE0C2)),
                ),

                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Periode Perhitungan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                      ),
                    ),

                    SizedBox(height: 7),

                    Text(
                      '06.00 pagi - 03.30 pagi',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),

                    SizedBox(height: 15),

                    Text(
                      'Pivot Point hanya dapat dihitung setelah pasar ditutup.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
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

  Widget _buildSummaryCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Ringkasan Pivot Point',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: const Color(0xFFFFEAD6),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Column(
              children: [
                const Text(
                  'PIVOT POINT (PP) UTAMA',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  '1972.80',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: orangeColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildIndicatorRow('Open < Pivot Point (1972.80)', 'BUY', greenColor),

          const SizedBox(height: 8),

          _buildIndicatorRow('Open > Pivot Point (1972.80)', 'SELL', redColor),
        ],
      ),
    );
  }

  // ============================================================
  // INDICATOR
  // ============================================================

  Widget _buildIndicatorRow(String text, String indication, Color color) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
          ),

          child: Text(
            indication,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MARKET INPUT CARD
  // ============================================================

  Widget _buildMarketInputCard() {
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
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'DATA PASAR INPUT',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 15),

          _buildInputRow('Open', '1985'),

          _buildInputRow('High', '1960'),

          _buildInputRow('Low', '1972'),

          _buildInputRow('Close', '1972'),
        ],
      ),
    );
  }

  // ============================================================
  // INPUT ROW
  // ============================================================

  Widget _buildInputRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PIVOT LEVEL
  // ============================================================

  Widget _buildPivotLevel({
    required String level,
    required String formula,
    required String value,
    required Color color,
    bool isMainPivot = false,
  }) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: color.withOpacity(0.30), width: 1.2),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 7,
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
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(13),
            ),

            child: Center(
              child: Text(
                level,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  formula,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMainPivot ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: color,
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
  // MIDPOINT
  // ============================================================

  Widget _buildMidpoint({required String formula, required String value}) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),

      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F1),

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFE8DDD2)),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.swap_vert_rounded,
            size: 18,
            color: Color(0xFF8A7767),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'MIDPOINT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8A7767),
                    letterSpacing: 0.7,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  formula,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),
        ],
      ),
    );
  }
}
