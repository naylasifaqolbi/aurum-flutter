import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  void _goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  void _onNavbarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Untuk sementara:
    // hanya halaman Beranda yang aktif.
    //
    // Halaman Kalkulator, Riwayat, dan Profil
    // akan dibuat pada tahap berikutnya.
    if (index == 1) {
      _goToDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // CONTENT
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 16),

                    // ==========================================
                    // HEADER
                    // ==========================================
                    Row(
                      children: [
                        // LOGO
                        Image.asset(
                          'assets/images/logo.png',
                          width: 42,
                          height: 42,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(width: 10),

                        // NAMA APLIKASI
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

                        // NOTIFICATION
                        IconButton(
                          onPressed: () {
                            // Fitur notifikasi akan dibuat nanti.
                          },

                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            size: 28,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 38),

                    // ==========================================
                    // GREETING
                    // ==========================================
                    const Text(
                      'Selamat datang',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Rosalinda',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Semangat bekerja hari ini!',
                      style: TextStyle(fontSize: 15, color: Color(0xFF777777)),
                    ),

                    const SizedBox(height: 45),

                    // ==========================================
                    // MAIN TITLE
                    // ==========================================
                    const Text(
                      'Kelola dan Analisis Emasmu\n'
                      'dengan Lebih Mudah',
                      style: TextStyle(
                        fontSize: 24,
                        height: 1.25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ==========================================
                    // DESCRIPTION
                    // ==========================================
                    const Text(
                      'Aurum membantu kamu menghitung nilai dan\n'
                      'keuntungan emas fisik serta menganalisis\n'
                      'pergerakan harga menggunakan Pivot Point.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Color(0xFF777777),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ==========================================
                    // BUTTON
                    // ==========================================
                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton(
                        onPressed: _goToDashboard,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF28C28),
                          foregroundColor: Colors.white,
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Text(
                              'Mulai Menghitung Sekarang',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(width: 10),

                            Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // ==========================================
                    // DECORATION / ILLUSTRATION
                    // ==========================================
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 110,
                        height: 110,
                        fit: BoxFit.contain,
                        opacity: const AlwaysStoppedAnimation(0.08),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ==========================================
            // BOTTOM NAVIGATION BAR
            // ==========================================
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),

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
          // BERANDA
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),

            activeIcon: Icon(Icons.home_rounded),

            label: 'Beranda',
          ),

          // KALKULATOR
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),

            activeIcon: Icon(Icons.calculate_rounded),

            label: 'Kalkulator',
          ),

          // RIWAYAT
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),

            activeIcon: Icon(Icons.history_rounded),

            label: 'Riwayat',
          ),

          // PROFIL
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),

            activeIcon: Icon(Icons.person_rounded),

            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
