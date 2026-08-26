import 'package:flutter/material.dart';

import '../calculator/physical_gold_calculator.dart';
import '../calculator/pivot_calculator.dart';

class CalculatorMenuScreen extends StatefulWidget {
  const CalculatorMenuScreen({super.key});

  @override
  State<CalculatorMenuScreen> createState() => _CalculatorMenuScreenState();
}

class _CalculatorMenuScreenState extends State<CalculatorMenuScreen> {
  Widget? _selectedCalculator;

  void _openCalculator(Widget calculator) {
    setState(() {
      _selectedCalculator = calculator;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedCalculator != null) {
      return _selectedCalculator!;
    }

    return _buildCalculatorMenu();
  }

  Widget _buildCalculatorMenu() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ================================================
              // HEADER
              // ================================================
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

              // ================================================
              // TITLE
              // ================================================
              const Text(
                'Kalkulator',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF28C28),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Pilih jenis kalkulator yang ingin digunakan.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777777),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // ================================================
              // EMAS FISIK
              // ================================================
              _buildCalculatorCard(
                icon: Icons.monetization_on_outlined,
                title: 'Kalkulator Emas Fisik',
                description:
                    'Hitung keuntungan atau kerugian '
                    'dari transaksi emas fisik.',
                page: const PhysicalGoldCalculator(),
              ),

              const SizedBox(height: 16),

              // ================================================
              // PIVOT POINT
              // ================================================
              _buildCalculatorCard(
                icon: Icons.show_chart_rounded,
                title: 'Kalkulator Pivot Point',
                description:
                    'Hitung Pivot Point berdasarkan '
                    'harga High, Low, dan Close.',
                page: const PivotCalculator(),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CARD
  // ==========================================================

  Widget _buildCalculatorCard({
    required IconData icon,
    required String title,
    required String description,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        _openCalculator(page);
      },

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,

              decoration: BoxDecoration(
                color: const Color(0xFFFFE5CC),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Icon(icon, color: const Color(0xFFF28C28), size: 30),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D2B1F),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Color(0xFFF28C28),
            ),
          ],
        ),
      ),
    );
  }
}
