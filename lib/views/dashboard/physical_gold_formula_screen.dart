import 'package:flutter/material.dart';

class PhysicalGoldFormulaScreen extends StatelessWidget {
  const PhysicalGoldFormulaScreen({super.key});

  // ============================================================
  // COLOR
  // ============================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color orangeColor = Color(0xFFF28C28);
  static const Color darkBrown = Color(0xFF3D2B1F);
  static const Color lightOrange = Color(0xFFFFE5CC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(Icons.arrow_back_rounded, color: darkBrown),
        ),

        title: const Text(
          'Rumus Emas Fisik',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkBrown,
          ),
        ),

        centerTitle: false,
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // INTRODUCTION CARD
              // ==================================================
              _buildIntroductionCard(),

              const SizedBox(height: 24),

              // ==================================================
              // COMPONENT TITLE
              // ==================================================
              const Text(
                'Komponen Perhitungan',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // COMPONENT CARD
              // ==================================================
              _buildComponentCard(),

              const SizedBox(height: 28),

              // ==================================================
              // FORMULA TITLE
              // ==================================================
              const Text(
                'Rumus Emas Fisik',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Ada 5 tahap perhitungan dalam Rumus Emas Fisik.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // TAHAP 1
              // ==================================================
              _buildFormulaStep(
                number: '1',
                title: 'TAHAP 1',
                formula: 'Harga Beli × Kurs ÷ Toz',
              ),

              const SizedBox(height: 14),

              // ==================================================
              // TAHAP 2
              // ==================================================
              _buildFormulaStep(
                number: '2',
                title: 'TAHAP 2',
                formula: 'Harga Jual × Kurs ÷ Toz',
              ),

              const SizedBox(height: 14),

              // ==================================================
              // TAHAP 3
              // ==================================================
              _buildFormulaStep(
                number: '3',
                title: 'TAHAP 3',
                formula: 'Hasil Harga Jual (HJ) − Hasil Harga Beli (HB)',
              ),

              const SizedBox(height: 14),

              // ==================================================
              // TAHAP 4
              // ==================================================
              _buildFormulaStep(
                number: '4',
                title: 'TAHAP 4',
                formula: 'Modal ÷ Harga Beli',
                note:
                    'Catatan: Hasil ditampilkan dengan 2 angka '
                    'di belakang koma.',
              ),

              const SizedBox(height: 14),

              // ==================================================
              // TAHAP 5
              // ==================================================
              _buildFormulaStep(
                number: '5',
                title: 'TAHAP 5',
                formula: 'Hasil (HJ − HB) × Hasil (Modal ÷ HB)',
              ),

              const SizedBox(height: 24),

              // ==================================================
              // INFORMATION CARD
              // ==================================================
              _buildInformationCard(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INTRODUCTION CARD
  // ============================================================

  Widget _buildIntroductionCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: const Color(0xFFFFE0C2), width: 1),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ICON
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: lightOrange,
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.monetization_on_outlined,
              color: orangeColor,
              size: 29,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Emas Fisik',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Metode perhitungan untuk mengetahui '
            'estimasi keuntungan dari transaksi emas '
            'fisik berdasarkan data yang kamu masukkan.',
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.6),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMPONENT CARD
  // ============================================================

  Widget _buildComponentCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xFFFFE0C2), width: 1),

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
          _buildComponentItem(
            icon: Icons.account_balance_wallet_outlined,
            text: 'Modal',
          ),

          const SizedBox(height: 12),

          _buildComponentItem(
            icon: Icons.currency_exchange_rounded,
            text: 'Kurs',
          ),

          const SizedBox(height: 12),

          _buildComponentItem(icon: Icons.scale_outlined, text: 'Toz (31,1)'),

          const SizedBox(height: 12),

          _buildComponentItem(
            icon: Icons.sell_outlined,
            text: 'Harga Jual (HJ)',
          ),

          const SizedBox(height: 12),

          _buildComponentItem(
            icon: Icons.shopping_cart_outlined,
            text: 'Harga Beli (HB)',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMPONENT ITEM
  // ============================================================

  Widget _buildComponentItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: lightOrange,
            borderRadius: BorderRadius.circular(11),
          ),

          child: Icon(icon, color: orangeColor, size: 20),
        ),

        const SizedBox(width: 12),

        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: darkBrown,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FORMULA STEP CARD
  // ============================================================

  Widget _buildFormulaStep({
    required String number,
    required String title,
    required String formula,
    String? note,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xFFFFE0C2), width: 1),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 9,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ======================================================
          // NUMBER
          // ======================================================
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: orangeColor,
              borderRadius: BorderRadius.circular(13),
            ),

            alignment: Alignment.center,

            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 15),

          // ======================================================
          // CONTENT
          // ======================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: orangeColor,
                    letterSpacing: 0.8,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  formula,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                    height: 1.4,
                  ),
                ),

                if (note != null) ...[
                  const SizedBox(height: 9),

                  Text(
                    note,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMATION CARD
  // ============================================================

  Widget _buildInformationCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFFFFEAD6),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xFFFFD4AD)),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Icon(Icons.info_outline_rounded, color: orangeColor, size: 22),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Hasil perhitungan digunakan sebagai acuan '
              'dalam mengestimasi keuntungan transaksi '
              'emas fisik.',
              style: const TextStyle(
                fontSize: 12,
                color: darkBrown,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
