import 'package:flutter/material.dart';

import 'package:aurum/views/calculator/physical_gold_calculator.dart';
import 'package:aurum/views/calculator/pivot_calculator.dart';
import 'package:aurum/views/calculator/pivot_hangseng_calculator.dart';
import 'package:aurum/views/calculator/nest_calculator.dart';

class CalculatorMenuScreen extends StatefulWidget {
  const CalculatorMenuScreen({super.key});

  @override
  State<CalculatorMenuScreen> createState() => _CalculatorMenuScreenState();
}

class _CalculatorMenuScreenState extends State<CalculatorMenuScreen> {
  Widget? _selectedCalculator;

  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color orangeColor = Color(0xFFF28C28);
  static const Color darkBrownColor = Color(0xFF3D2B1F);
  static const Color lightOrangeColor = Color(0xFFFFE5CC);

  @override
  Widget build(BuildContext context) {
    if (_selectedCalculator != null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(child: _selectedCalculator!),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 28),

              _buildSectionTitle(
                title: 'Kalkulator',
                subtitle: 'Pilih kalkulator yang ingin kamu gunakan.',
              ),

              const SizedBox(height: 16),

              _buildCalculatorList(),

              const SizedBox(height: 28),

              _buildSectionTitle(
                title: 'Konsep Transaksi',
                subtitle:
                    'Gunakan fitur analisis untuk membantu membaca kondisi pasar.',
              ),

              const SizedBox(height: 16),

              _buildTransactionConceptList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AURUM',
              style: TextStyle(
                color: orangeColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Gold Analysis & Calculator',
              style: TextStyle(color: darkBrownColor, fontSize: 13),
            ),
          ],
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: lightOrangeColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: orangeColor,
            size: 25,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: darkBrownColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildCalculatorList() {
    return Column(
      children: [
        _buildCalculatorCard(
          icon: Icons.monetization_on_outlined,
          title: 'Gold Calcu',
          description:
              'Menghitung estimasi jumlah emas dan keuntungan berdasarkan modal, kurs, harga beli, dan harga jual.',
          onTap: () {
            setState(() {
              _selectedCalculator = PhysicalGoldCalculator(
                onBack: () {
                  setState(() {
                    _selectedCalculator = null;
                  });
                },
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildTransactionConceptList() {
    return Column(
      children: [
        _buildCalculatorCard(
          icon: Icons.show_chart_rounded,
          title: 'Pivot Emas',
          description:
              'Menghitung Pivot Point emas berdasarkan nilai High, Low, dan Close.',
          onTap: () {
            setState(() {
              _selectedCalculator = PivotCalculator(
                onBack: () {
                  setState(() {
                    _selectedCalculator = null;
                  });
                },
              );
            });
          },
        ),

        const SizedBox(height: 16),

        _buildCalculatorCard(
          icon: Icons.trending_up_rounded,
          title: 'Pivot Hangseng',
          description:
              'Menghitung Pivot Point Hang Seng berdasarkan nilai High, Low, dan Close.',
          onTap: () {
            setState(() {
              _selectedCalculator = PivotHangsengCalculator(
                onBack: () {
                  setState(() {
                    _selectedCalculator = null;
                  });
                },
              );
            });
          },
        ),

        const SizedBox(height: 16),

        _buildCalculatorCard(
          icon: Icons.account_tree_outlined,
          title: 'Nest',
          description:
              'Menampilkan indikator BUY, SELL, atau NETRAL berdasarkan perbandingan harga Open dan Close.',
          onTap: () {
            setState(() {
              _selectedCalculator = NestCalculatorScreen(
                onBack: () {
                  setState(() {
                    _selectedCalculator = null;
                  });
                },
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildCalculatorCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: lightOrangeColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: lightOrangeColor,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(icon, color: orangeColor, size: 30),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: darkBrownColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12.5,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: orangeColor,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}
