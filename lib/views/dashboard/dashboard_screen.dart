import 'package:flutter/material.dart';
import '../calculator/physical_gold_calculator.dart';
import '../calculator/pivot_calculator.dart';
import '../history/history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Kalkulator = index 1
  int _selectedIndex = 1;

  void _onNavbarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HistoryScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // CONTENT DASHBOARD
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 10),

                    // ==========================================
                    // TITLE
                    // ==========================================
                    const Text(
                      'Selamat Datang di Aurum',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D2B1F),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Aplikasi untuk membantu menghitung '
                      'emas fisik dan Pivot Point dengan mudah.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ==========================================
                    // MENU KALKULATOR
                    // ==========================================
                    const Text(
                      'Menu Kalkulator',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D2B1F),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ==========================================
                    // KALKULATOR EMAS FISIK
                    // ==========================================
                    _buildCalculatorCard(
                      icon: Icons.monetization_on_outlined,
                      title: 'Kalkulator Emas Fisik',
                      description:
                          'Hitung keuntungan atau kerugian dari transaksi emas fisik.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PhysicalGoldCalculator(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // ==========================================
                    // KALKULATOR PIVOT POINT
                    // ==========================================
                    _buildCalculatorCard(
                      icon: Icons.show_chart,
                      title: 'Kalkulator Pivot Point',
                      description:
                          'Hitung Pivot Point berdasarkan harga High, Low, dan Close.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PivotCalculator(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // ==========================================
                    // INFORMASI
                    // ==========================================
                    const Text(
                      'Informasi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D2B1F),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFFF28C28),
                            size: 30,
                          ),

                          SizedBox(height: 12),

                          Text(
                            'Tentang Aurum',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3D2B1F),
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Aurum membantu pengguna melakukan perhitungan '
                            'emas fisik dan Pivot Point dengan lebih mudah, '
                            'cepat, dan praktis.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ],
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

  // ==================================================
  // CALCULATOR CARD
  // ==================================================
  Widget _buildCalculatorCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            // ICON
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

            // TEXT
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

            // ARROW
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

  // ==================================================
  // BOTTOM NAVIGATION BAR
  // ==================================================
  Widget _buildBottomNavigationBar() {
    return Container(
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
          // ==========================================
          // BERANDA
          // ==========================================
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),

            activeIcon: Icon(Icons.home_rounded),

            label: 'Beranda',
          ),

          // ==========================================
          // KALKULATOR
          // ==========================================
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),

            activeIcon: Icon(Icons.calculate_rounded),

            label: 'Kalkulator',
          ),

          // ==========================================
          // RIWAYAT
          // ==========================================
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),

            activeIcon: Icon(Icons.history_rounded),

            label: 'Riwayat',
          ),

          // ==========================================
          // PROFIL
          // ==========================================
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
