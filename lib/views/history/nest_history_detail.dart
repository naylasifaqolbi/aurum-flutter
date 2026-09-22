import 'package:flutter/material.dart';

class NestHistoryDetail extends StatelessWidget {
  const NestHistoryDetail({super.key});

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
                          Icons.account_tree_outlined,
                          color: orangeColor,
                          size: 16,
                        ),

                        SizedBox(width: 5),

                        Text(
                          'KALKULATOR NEST',
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

              const Text(
                '24 Okt 2026, 10:15 WIB',
                style: TextStyle(fontSize: 13, color: Color(0xFF667085)),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // SUMMARY CARD
              // ==================================================
              _buildSummaryCard(),

              const SizedBox(height: 18),

              // ==================================================
              // ANALYSIS CARD
              // ==================================================
              _buildAnalysisCard(),

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

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),

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
            'Ringkasan Indikator Nest',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF667085),
            ),
          ),

          const SizedBox(height: 12),

          // ==================================================
          // INDICATOR
          // ==================================================
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),

              decoration: BoxDecoration(
                color: greenColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.trending_up_rounded, color: greenColor, size: 20),

                  SizedBox(width: 7),

                  Text(
                    'BUY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: greenColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

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
                child: _buildInputBox(label: 'Open', value: '2650'),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _buildInputBox(label: 'Close', value: '2680'),
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
  // ANALYSIS CARD
  // ============================================================

  Widget _buildAnalysisCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE1E7EF), width: 1),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Analisis',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(10),
            ),

            child: const Text(
              'Harga Close lebih tinggi daripada Harga Open, '
              'sehingga indikator Nest menunjukkan kondisi BUY.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Color(0xFF667085),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Text(
                'Indikator',
                style: TextStyle(fontSize: 11, color: Color(0xFF98A2B3)),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: greenColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: const Text(
                  'BUY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: greenColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
