import 'package:flutter/material.dart';

class PhysicalGoldHistoryDetail extends StatelessWidget {
  const PhysicalGoldHistoryDetail({super.key});

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
                  '24 Okt 2026, 14:30 WIB',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // TITLE
              // ==================================================
              const Text(
                'KALKULATOR EMAS FISIK',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // TRANSAKSI
              // ==================================================
              _buildSectionCard(
                title: 'TRANSAKSI',
                child: Column(
                  children: [
                    _buildTransactionRow('Modal', 'Rp 50.000.000'),

                    _buildDivider(),

                    _buildTransactionRow('Kurs', 'Rp 16.000'),

                    _buildDivider(),

                    _buildTransactionRow('TOz', '31,1'),

                    _buildDivider(),

                    _buildTransactionRow('Harga Beli', 'Rp 1.000.000'),

                    _buildDivider(),

                    _buildTransactionRow('Harga Jual', 'Rp 1.150.000'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // HASIL PERHITUNGAN
              // ==================================================
              _buildResultCard(),

              const SizedBox(height: 20),

              // ==================================================
              // INFO
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
                      'RIWAYAT PERHITUNGAN',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Emas / USD (XAUUSD)',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

  Widget _buildSectionCard({required String title, required Widget child}) {
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
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 15),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // TRANSACTION ROW
  // ============================================================

  Widget _buildTransactionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
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
  // DIVIDER
  // ============================================================

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFF0E5DA));
  }

  // ============================================================
  // RESULT CARD
  // ============================================================

  Widget _buildResultCard() {
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
            'HASIL PERHITUNGAN',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Estimasi Keuntungan Bersih',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),

          const SizedBox(height: 5),

          const Text(
            '+ Rp 7.500.000',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E8B57),
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Keuntungan dari transaksi emas fisik',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
