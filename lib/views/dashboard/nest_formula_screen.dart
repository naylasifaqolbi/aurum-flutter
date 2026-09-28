import 'package:flutter/material.dart';

class NestFormulaScreen extends StatelessWidget {
  const NestFormulaScreen({super.key});

  // ============================================================
  // COLOR
  // ============================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color orangeColor = Color(0xFFF28C28);
  static const Color darkBrown = Color(0xFF3D2B1F);
  static const Color lightOrange = Color(0xFFFFE5CC);

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
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
          'Rumus NEST',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: orangeColor,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // HEADER
            // ==================================================
            _buildHeaderCard(),

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

            _buildComponentCard(),

            const SizedBox(height: 28),

            // ==================================================
            // FORMULA TITLE
            // ==================================================
            const Text(
              'Indikasi NEST',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'NEST menentukan indikasi berdasarkan '
              'perbandingan harga Close terhadap harga Open.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // SELL
            // ==================================================
            _buildIndicationCard(
              number: '1',
              title: 'SELL',
              condition: 'Close < Open',
              description:
                  'Jika harga Close berada di bawah harga Open, '
                  'maka indikasi yang dihasilkan adalah SELL.',
            ),

            const SizedBox(height: 14),

            // ==================================================
            // BUY
            // ==================================================
            _buildIndicationCard(
              number: '2',
              title: 'BUY',
              condition: 'Close > Open',
              description:
                  'Jika harga Close berada di atas harga Open, '
                  'maka indikasi yang dihasilkan adalah BUY.',
            ),

            const SizedBox(height: 14),

            // ==================================================
            // NETRAL
            // ==================================================
            _buildIndicationCard(
              number: '3',
              title: 'NETRAL',
              condition: 'Close = Open',
              description:
                  'Jika harga Close sama dengan harga Open, '
                  'maka tidak terdapat perubahan harga.',
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
    );
  }

  // ============================================================
  // HEADER CARD
  // ============================================================

  Widget _buildHeaderCard() {
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
          const Text(
            'NEST',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Metode sederhana untuk menentukan indikasi '
            'BUY atau SELL berdasarkan perbandingan '
            'harga Open dan Close.',
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

        border: Border.all(color: const Color(0xFFFFE0C2)),

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
          _buildComponentRow(
            icon: Icons.login_rounded,
            label: 'Open',
            description: 'Harga pembukaan',
          ),

          const SizedBox(height: 12),

          _buildComponentRow(
            icon: Icons.logout_rounded,
            label: 'Close',
            description: 'Harga penutupan',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMPONENT ROW
  // ============================================================

  Widget _buildComponentRow({
    required IconData icon,
    required String label,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,

          decoration: BoxDecoration(
            color: lightOrange,
            borderRadius: BorderRadius.circular(11),
          ),

          child: Icon(icon, color: orangeColor, size: 21),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                description,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INDICATION CARD
  // ============================================================

  Widget _buildIndicationCard({
    required String number,
    required String title,
    required String condition,
    required String description,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xFFFFE0C2)),

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

                const SizedBox(height: 6),

                Text(
                  condition,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.5,
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
              'NEST hanya menggunakan dua data utama, '
              'yaitu harga Open dan Close. Hasilnya berupa '
              'indikasi BUY, SELL, atau NETRAL.',
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
