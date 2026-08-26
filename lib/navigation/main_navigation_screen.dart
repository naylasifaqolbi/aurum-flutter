import 'package:flutter/material.dart';

// ==========================================================
// IMPORT HALAMAN
// ==========================================================

import '../views/dashboard/dashboard_screen.dart';
import '../views/dashboard/landing_page.dart';
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
  // HALAMAN NAVBAR
  // ==========================================================
  //
  // Tidak menggunakan const karena DashboardScreen
  // menerima callback onGoToCalculator.
  //

  late final List<Widget> _pages;

  // ==========================================================
  // INIT STATE
  // ==========================================================

  @override
  void initState() {
    super.initState();

    _pages = [
      // ========================================================
      // 1. DASHBOARD / BERANDA
      // ========================================================
      DashboardScreen(
        onGoToCalculator: () {
          setState(() {
            _selectedIndex = 1;
          });
        },
      ),

      // ========================================================
      // 2. KALKULATOR
      // ========================================================
      const CalculatorMenuScreen(),

      // ========================================================
      // 3. RIWAYAT
      // ========================================================
      const HistoryScreen(),

      // ========================================================
      // 4. PROFIL
      // ========================================================
      const ProfileScreen(),
    ];
  }

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

      // ========================================================
      // CONTENT
      // ========================================================
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // ========================================================
      // SATU-SATUNYA BOTTOM NAVIGATION BAR
      // ========================================================
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
          // ======================================================
          // INDEX AKTIF
          // ======================================================
          currentIndex: _selectedIndex,

          // ======================================================
          // EVENT TAP
          // ======================================================
          onTap: _onNavbarTap,

          // ======================================================
          // TYPE
          // ======================================================
          type: BottomNavigationBarType.fixed,

          // ======================================================
          // BACKGROUND
          // ======================================================
          backgroundColor: Colors.white,

          elevation: 0,

          // ======================================================
          // COLOR
          // ======================================================
          selectedItemColor: const Color(0xFFF28C28),

          unselectedItemColor: const Color(0xFF999999),

          // ======================================================
          // FONT SIZE
          // ======================================================
          selectedFontSize: 11,

          unselectedFontSize: 11,

          // ======================================================
          // ITEMS
          // ======================================================
          items: const [
            // ====================================================
            // 1. BERANDA
            // ====================================================
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),

              activeIcon: Icon(Icons.home_rounded),

              label: 'Beranda',
            ),

            // ====================================================
            // 2. KALKULATOR
            // ====================================================
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),

              activeIcon: Icon(Icons.calculate_rounded),

              label: 'Kalkulator',
            ),

            // ====================================================
            // 3. RIWAYAT
            // ====================================================
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),

              activeIcon: Icon(Icons.history_rounded),

              label: 'Riwayat',
            ),

            // ====================================================
            // 4. PROFIL
            // ====================================================
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
