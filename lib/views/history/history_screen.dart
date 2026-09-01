import 'package:flutter/material.dart';

import 'physical_gold_history_detail.dart';
import 'pivot_history_detail.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // ============================================================
  // COLOR
  // ============================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color orangeColor = Color(0xFFF28C28);
  static const Color darkBrown = Color(0xFF3D2B1F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 64,
        titleSpacing: 20,
        // ==================================================
        // HEADER
        // ==================================================
        title: Row(
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
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // TITLE
              // ==================================================
              const Text(
                'Riwayat Perhitungan',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Tinjau analisis Emas dan Pivot terbaru anda',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777777),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // FILTER
              // ==================================================
              Row(
                children: [
                  _buildFilter(label: 'Semua', selected: true),

                  const SizedBox(width: 10),

                  _buildFilter(label: 'Emas Fisik', selected: false),

                  const SizedBox(width: 10),

                  _buildFilter(label: 'Pivot Point', selected: false),
                ],
              ),

              const SizedBox(height: 24),

              // ==================================================
              // HISTORY 1 - EMAS
              // ==================================================
              _buildHistoryCard(
                context: context,
                type: 'EMAS FISIK',
                date: '24 Okt 2026, 14:32',
                result: 'Profit',
                value: '+Rp 30.000.000',
                subtitle1: 'Harga Beli/Jual',
                subtitleValue1: '1.250k / 1.310k',
                subtitle2: 'Modal',
                subtitleValue2: 'Rp 625.000.000',
                icon: Icons.monetization_on_outlined,
                iconColor: orangeColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhysicalGoldHistoryDetail(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ==================================================
              // HISTORY 2 - PIVOT
              // ==================================================
              _buildHistoryCard(
                context: context,
                type: 'PIVOT POINT',
                date: '24 Okt 2026, 09:15',
                result: 'Pivot Point (PP)',
                value: '1972.80',
                subtitle1: 'High / Low / Close',
                subtitleValue1: '1985 / 1960 / 1972',
                icon: Icons.show_chart_rounded,
                iconColor: orangeColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PivotHistoryDetail(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ==================================================
              // HISTORY 3 - PIVOT
              // ==================================================
              _buildHistoryCard(
                context: context,
                type: 'PIVOT POINT',
                date: '24 Okt 2026, 09:15',
                result: 'Pivot Point (PP)',
                value: '1234.00',
                subtitle1: 'High / Low / Close',
                subtitleValue1: '1980 / 1955 / 1975',
                icon: Icons.show_chart_rounded,
                iconColor: orangeColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PivotHistoryDetail(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FILTER
  // ============================================================

  Widget _buildFilter({required String label, required bool selected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),

      decoration: BoxDecoration(
        color: selected ? orangeColor : Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: selected ? orangeColor : const Color(0xFFE5D9CE),
        ),
      ),

      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : const Color(0xFF777777),
        ),
      ),
    );
  }

  // ============================================================
  // HISTORY CARD
  // ============================================================

  Widget _buildHistoryCard({
    required BuildContext context,
    required String type,
    required String date,
    required String result,
    required String value,
    required String subtitle1,
    required String subtitleValue1,
    required IconData icon,
    required Color iconColor,
    String? subtitle2,
    String? subtitleValue2,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(18),

        child: Container(
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

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // ICON
              // ==================================================
              Container(
                width: 52,
                height: 52,

                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5CC),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Icon(icon, color: iconColor, size: 28),
              ),

              const SizedBox(width: 15),

              // ==================================================
              // CONTENT
              // ==================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      type,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF999999),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      result,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF777777),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: orangeColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      subtitle1,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF999999),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitleValue1,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: darkBrown,
                      ),
                    ),

                    if (subtitle2 != null && subtitleValue2 != null) ...[
                      const SizedBox(height: 10),

                      Text(
                        subtitle2,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitleValue2,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: darkBrown,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ==================================================
              // ARROW
              // ==================================================
              const Padding(
                padding: EdgeInsets.only(top: 3),

                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: orangeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
