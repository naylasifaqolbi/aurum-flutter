import 'package:flutter/material.dart';

class PivotFormulaScreen extends StatelessWidget {
  const PivotFormulaScreen({super.key});

  // ==========================================================
  // COLOR
  // ==========================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color orangeColor = Color(0xFFF28C28);
  static const Color darkBrown = Color(0xFF3D2B1F);
  static const Color lightOrange = Color(0xFFFFE5CC);

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,

        iconTheme: const IconThemeData(color: darkBrown),

        title: const Text(
          'Pivot Point',
          style: TextStyle(color: darkBrown, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // PENJELASAN
            // ==================================================
            _buildHeaderCard(),

            const SizedBox(height: 20),

            // ==================================================
            // KOMPONEN PERHITUNGAN
            // ==================================================
            _buildComponentCard(),

            const SizedBox(height: 28),

            // ==================================================
            // JUDUL RUMUS
            // ==================================================
            const Text(
              'Rumus Pivot Points',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // RESISTANCE
            // ==================================================
            _buildSectionTitle(
              'Resistance (Atas)',
              Icons.keyboard_arrow_up_rounded,
            ),

            const SizedBox(height: 15),

            // R4
            _buildResistanceItem(
              title: 'R4',
              formula: 'PP + (High - Low) × 3',
              midpoint: '(R4 + R3) / 2',
            ),

            // R3
            _buildResistanceItem(
              title: 'R3',
              formula: 'PP + (High - Low) × 2',
              midpoint: '(R3 + R2) / 2',
            ),

            // R2
            _buildResistanceItem(
              title: 'R2',
              formula: 'PP + (High - Low)',
              midpoint: '(R2 + R1) / 2',
            ),

            // R1
            _buildResistanceItem(
              title: 'R1',
              formula: '2 × PP - Low',
              midpoint: '(PP + R1) / 2',
            ),

            const SizedBox(height: 10),

            // ==================================================
            // PIVOT POINT UTAMA
            // ==================================================
            _buildPivotPointCard(),

            const SizedBox(height: 25),

            // ==================================================
            // SUPPORT
            // ==================================================
            _buildSectionTitle(
              'Support (Bawah)',
              Icons.keyboard_arrow_down_rounded,
            ),

            const SizedBox(height: 15),

            // S1
            _buildSupportItem(
              midpoint: '(PP + S1) / 2',
              title: 'S1',
              formula: '2 × PP - High',
            ),

            // S2
            _buildSupportItem(
              midpoint: '(S1 + S2) / 2',
              title: 'S2',
              formula: 'PP - (High - Low)',
            ),

            // S3
            _buildSupportItem(
              midpoint: '(S2 + S3) / 2',
              title: 'S3',
              formula: 'PP - (High - Low) × 2',
            ),

            // S4
            _buildSupportItem(
              midpoint: '(S3 + S4) / 2',
              title: 'S4',
              formula: 'PP - (High - Low) × 3',
            ),

            const SizedBox(height: 25),

            // ==================================================
            // INDIKASI PERGERAKAN
            // ==================================================
            _buildBuySellCard(),

            const SizedBox(height: 20),

            // ==================================================
            // CATATAN
            // ==================================================
            _buildNoteCard(),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER CARD
  // ==========================================================

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xFFFFE0C2)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            'Pivot Point',

            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          SizedBox(height: 10),

          Text(
            'Metode perhitungan untuk menentukan '
            'level Pivot Point, Resistance, dan '
            'Support berdasarkan data High, '
            'Low, dan Close.',

            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.6),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // COMPONENT CARD
  // ==========================================================

  Widget _buildComponentCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xFFFFE0C2)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Komponen Perhitungan',

            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 15),

          _buildComponentRow(label: 'High', description: 'Harga tertinggi'),

          const SizedBox(height: 10),

          _buildComponentRow(label: 'Low', description: 'Harga terendah'),

          const SizedBox(height: 10),

          _buildComponentRow(label: 'Close', description: 'Harga penutupan'),
        ],
      ),
    );
  }

  Widget _buildComponentRow({
    required String label,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          width: 48,
          padding: const EdgeInsets.symmetric(vertical: 6),

          decoration: BoxDecoration(
            color: lightOrange,
            borderRadius: BorderRadius.circular(8),
          ),

          child: Text(
            label,
            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: orangeColor,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            description,

            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: orangeColor, size: 25),

        const SizedBox(width: 6),

        Text(
          title,

          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: orangeColor,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // RESISTANCE ITEM
  //
  // Urutan:
  //
  // R4
  // Midpoint
  //
  // R3
  // Midpoint
  //
  // dst.
  // ==========================================================

  Widget _buildResistanceItem({
    required String title,
    required String formula,
    required String midpoint,
  }) {
    return Column(
      children: [
        // ======================================================
        // R CARD
        // ======================================================
        Container(
          width: double.infinity,

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(17),

            border: Border.all(color: const Color(0xFFFFD8B5)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                formula,

                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: darkBrown,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ======================================================
        // ARROW
        // ======================================================
        const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFFCC8A4D),
          size: 22,
        ),

        const SizedBox(height: 4),

        // ======================================================
        // MIDPOINT CARD
        // ======================================================
        _buildMidpointCard(midpoint),

        const SizedBox(height: 16),
      ],
    );
  }

  // ==========================================================
  // SUPPORT ITEM
  //
  // Urutan:
  //
  // Midpoint
  // S1
  //
  // Midpoint
  // S2
  //
  // dst.
  // ==========================================================

  Widget _buildSupportItem({
    required String midpoint,
    required String title,
    required String formula,
  }) {
    return Column(
      children: [
        // ======================================================
        // MIDPOINT CARD
        // ======================================================
        _buildMidpointCard(midpoint),

        const SizedBox(height: 8),

        // ======================================================
        // ARROW
        // ======================================================
        const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFFCC8A4D),
          size: 22,
        ),

        const SizedBox(height: 4),

        // ======================================================
        // S CARD
        // ======================================================
        Container(
          width: double.infinity,

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(17),

            border: Border.all(color: const Color(0xFFFFD8B5)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                formula,

                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: darkBrown,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  // ==========================================================
  // MIDPOINT CARD
  // ==========================================================

  Widget _buildMidpointCard(String midpoint) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),

      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E7),

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: const Color(0xFFFFDDBD)),
      ),

      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,

            decoration: BoxDecoration(
              color: lightOrange,
              borderRadius: BorderRadius.circular(10),
            ),

            child: const Icon(
              Icons.drag_handle_rounded,
              size: 19,
              color: orangeColor,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Midpoint',

                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: orangeColor,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  midpoint,

                  style: const TextStyle(
                    fontSize: 13,
                    color: darkBrown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PIVOT POINT CARD
  // ==========================================================

  Widget _buildPivotPointCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFFFFEAD6),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xFFFFC98F), width: 1.2),

        boxShadow: [
          BoxShadow(
            color: orangeColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          const Text(
            'PP',

            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: orangeColor,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Pivot Point',

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(13),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Text(
              'PP = (High + Low + Close) / 3',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Nilai pusat sebagai dasar perhitungan '
            'Resistance dan Support.',

            textAlign: TextAlign.center,

            style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BUY SELL CARD
  // ==========================================================

  Widget _buildBuySellCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFFFFEAD6),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xFFFFD4AD)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Indikasi Pergerakan',

            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 15),

          // BUY
          _buildSignalRow(
            icon: Icons.trending_up_rounded,
            title: 'BUY',
            condition: 'Open < Pivot Point',
          ),

          const SizedBox(height: 12),

          // SELL
          _buildSignalRow(
            icon: Icons.trending_down_rounded,
            title: 'SELL',
            condition: 'Open > Pivot Point',
          ),
        ],
      ),
    );
  }

  Widget _buildSignalRow({
    required IconData icon,
    required String title,
    required String condition,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Icon(icon, color: orangeColor, size: 25),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              condition,

              style: const TextStyle(fontSize: 14, color: darkBrown),
            ),
          ),

          Text(
            title,

            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: orangeColor,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // NOTE CARD
  // ==========================================================

  Widget _buildNoteCard() {
    return Container(
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
            'Catatan',

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          SizedBox(height: 10),

          Text(
            'Pivot Point hanya dapat dihitung setelah '
            'pasar ditutup.',

            style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
          ),

          SizedBox(height: 8),

          Text(
            'Periode: 06.00 pagi - 03.30 pagi',

            style: TextStyle(
              fontSize: 13,
              color: orangeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
