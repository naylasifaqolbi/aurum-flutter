import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // ==================================================
  // NAVBAR
  // ==================================================

  // 0 = Beranda
  // 1 = Kalkulator
  // 2 = Riwayat
  // 3 = Profil
  int _selectedIndex = 2;

  void _onNavbarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi ke halaman lain akan dibuat
    // setelah seluruh halaman selesai.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // CONTENT
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
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

                        // NOTIFIKASI
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

                    const SizedBox(height: 35),

                    // ==========================================
                    // TITLE
                    // ==========================================
                    const Text(
                      'Riwayat Perhitungan',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF28C28),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Tinjau analisis Emas dan Pivot terbaru anda.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF777777),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ==========================================
                    // RIWAYAT DUMMY
                    // ==========================================
                    _buildHistoryCard(
                      type: 'Emas Fisik',
                      date: '18 Agustus 2026',
                      time: '10:30',
                      result: 'Keuntungan',
                      value: 'Rp 1.250.000',
                      icon: Icons.monetization_on_outlined,
                    ),

                    const SizedBox(height: 16),

                    _buildHistoryCard(
                      type: 'Pivot Point',
                      date: '17 Agustus 2026',
                      time: '15:45',
                      result: 'Pivot Point',
                      value: '2.450.50',
                      icon: Icons.show_chart_rounded,
                    ),

                    const SizedBox(height: 16),

                    _buildHistoryCard(
                      type: 'Emas Fisik',
                      date: '16 Agustus 2026',
                      time: '09:20',
                      result: 'Keuntungan',
                      value: 'Rp 850.000',
                      icon: Icons.monetization_on_outlined,
                    ),

                    const SizedBox(height: 16),

                    _buildHistoryCard(
                      type: 'Pivot Point',
                      date: '15 Agustus 2026',
                      time: '14:10',
                      result: 'Pivot Point',
                      value: '2.425.75',
                      icon: Icons.show_chart_rounded,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // ==========================================
            // NAVBAR
            // ==========================================
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // HISTORY CARD
  // ==================================================

  Widget _buildHistoryCard({
    required String type,
    required String date,
    required String time,
    required String result,
    required String value,
    required IconData icon,
  }) {
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

      child: Row(
        children: [
          // ==========================================
          // ICON
          // ==========================================
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: const Color(0xFFFFE5CC),
              borderRadius: BorderRadius.circular(15),
            ),

            child: Icon(icon, color: const Color(0xFFF28C28), size: 28),
          ),

          const SizedBox(width: 15),

          // ==========================================
          // CONTENT
          // ==========================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D2B1F),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '$date • $time',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  result,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF777777),
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF28C28),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // ARROW
          // ==========================================
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 17,
            color: Color(0xFFF28C28),
          ),
        ],
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
