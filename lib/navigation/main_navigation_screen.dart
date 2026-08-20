import 'package:flutter/material.dart';

// ==========================================================
// IMPORT HALAMAN
// ==========================================================

import '../views/dashboard/dashboard_screen.dart';
import '../views/calculator/physical_gold_calculator.dart';
import '../views/calculator/pivot_calculator.dart';
import '../views/history/history_screen.dart';
import '../views/profile/profile_screen.dart';

// ==========================================================
// MAIN NAVIGATION SCREEN
// ==========================================================

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // ==========================================================
  // INDEX NAVBAR
  // ==========================================================
  //
  // 0 = Beranda
  // 1 = Kalkulator
  // 2 = Riwayat
  // 3 = Profil
  //
  int _selectedIndex = 0;

  // ==========================================================
  // HALAMAN UTAMA NAVBAR
  // ==========================================================

  final List<Widget> _pages = const [
    DashboardScreen(),
    CalculatorMenuScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  // ==========================================================
  // EVENT NAVBAR
  // ==========================================================

  void _onNavbarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      // ======================================================
      // CONTENT
      // ======================================================
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // ======================================================
      // SATU-SATUNYA BOTTOM NAVIGATION BAR
      // ======================================================
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,

          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, -3),
            ),
          ],
        ),

        child: BottomNavigationBar(
          currentIndex: _selectedIndex,

          onTap: _onNavbarTap,

          type: BottomNavigationBarType.fixed,

          backgroundColor: Colors.white,

          elevation: 0,

          selectedItemColor: const Color(0xFFF28C28),

          unselectedItemColor: const Color(0xFF999999),

          selectedFontSize: 11,

          unselectedFontSize: 11,

          items: const [
            // ==================================================
            // 1. BERANDA
            // ==================================================
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),

              activeIcon: Icon(Icons.home_rounded),

              label: 'Beranda',
            ),

            // ==================================================
            // 2. KALKULATOR
            // ==================================================
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),

              activeIcon: Icon(Icons.calculate_rounded),

              label: 'Kalkulator',
            ),

            // ==================================================
            // 3. RIWAYAT
            // ==================================================
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),

              activeIcon: Icon(Icons.history_rounded),

              label: 'Riwayat',
            ),

            // ==================================================
            // 4. PROFIL
            // ==================================================
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),

              activeIcon: Icon(Icons.person_rounded),

              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HALAMAN MENU KALKULATOR
// ============================================================

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

  void _backToCalculatorMenu() {
    setState(() {
      _selectedCalculator = null;
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
              // ==================================================
              // HEADER
              // ==================================================
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

              // ==================================================
              // TITLE
              // ==================================================
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

              // ==================================================
              // KALKULATOR EMAS FISIK
              // ==================================================
              _buildCalculatorCard(
                context: context,
                icon: Icons.monetization_on_outlined,
                title: 'Kalkulator Emas Fisik',
                description:
                    'Hitung keuntungan atau kerugian '
                    'dari transaksi emas fisik.',
                page: PhysicalGoldCalculator(),
              ),
              const SizedBox(height: 16),

              // ==================================================
              // KALKULATOR PIVOT POINT
              // ==================================================
              _buildCalculatorCard(
                context: context,

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
  // CARD KALKULATOR
  // ==========================================================

  Widget _buildCalculatorCard({
    required BuildContext context,
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
            // ==================================================
            // ICON
            // ==================================================
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

            // ==================================================
            // TEXT
            // ==================================================
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

            // ==================================================
            // ARROW
            // ==================================================
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
