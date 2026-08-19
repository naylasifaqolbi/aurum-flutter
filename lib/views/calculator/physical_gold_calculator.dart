import 'package:flutter/material.dart';

class PhysicalGoldCalculator extends StatefulWidget {
  const PhysicalGoldCalculator({super.key});

  @override
  State<PhysicalGoldCalculator> createState() => _PhysicalGoldCalculatorState();
}

class _PhysicalGoldCalculatorState extends State<PhysicalGoldCalculator> {
  // ==================================================
  // CONTROLLER INPUT
  // ==================================================

  final TextEditingController _modalController = TextEditingController();

  final TextEditingController _kursController = TextEditingController();

  final TextEditingController _hargaBeliController = TextEditingController();

  final TextEditingController _hargaJualController = TextEditingController();

  // Navbar
  int _selectedIndex = 1;

  @override
  void dispose() {
    _modalController.dispose();
    _kursController.dispose();
    _hargaBeliController.dispose();
    _hargaJualController.dispose();

    super.dispose();
  }

  // ==================================================
  // TOMBOL HITUNG
  // ==================================================

  void _hitung() {
    // Perhitungan akan dibuat pada tahap berikutnya.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perhitungan akan dibuat pada tahap berikutnya.'),
      ),
    );
  }

  // ==================================================
  // NAVBAR
  // ==================================================

  void _onNavbarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasi navbar akan dibuat setelah
    // seluruh halaman selesai dibuat.
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
                      'Hitung Emas Fisik',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF28C28),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Masukkan data transaksi emas fisik '
                      'untuk menghitung keuntungan atau kerugian.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF777777),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ==========================================
                    // MODAL
                    // ==========================================
                    _buildInputLabel('Modal (IDR)'),

                    const SizedBox(height: 8),

                    _buildInputField(
                      controller: _modalController,
                      hintText: 'Masukkan modal',
                      icon: Icons.account_balance_wallet_outlined,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 20),

                    // ==========================================
                    // KURS
                    // ==========================================
                    _buildInputLabel('Kurs (IDR)'),

                    const SizedBox(height: 8),

                    _buildInputField(
                      controller: _kursController,
                      hintText: 'Masukkan kurs',
                      icon: Icons.currency_exchange_rounded,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 20),

                    // ==========================================
                    // HARGA BELI
                    // ==========================================
                    _buildInputLabel('Harga Beli'),

                    const SizedBox(height: 8),

                    _buildInputField(
                      controller: _hargaBeliController,
                      hintText: 'Masukkan harga beli',
                      icon: Icons.shopping_cart_outlined,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 20),

                    // ==========================================
                    // HARGA JUAL
                    // ==========================================
                    _buildInputLabel('Harga Jual'),

                    const SizedBox(height: 8),

                    _buildInputField(
                      controller: _hargaJualController,
                      hintText: 'Masukkan harga jual',
                      icon: Icons.sell_outlined,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 32),

                    // ==========================================
                    // BUTTON HITUNG
                    // ==========================================
                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton(
                        onPressed: _hitung,

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
                            Icon(Icons.calculate_outlined, size: 21),

                            SizedBox(width: 10),

                            Text(
                              'Hitung',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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
  // LABEL INPUT
  // ==================================================

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }

  // ==================================================
  // INPUT FIELD
  // ==================================================

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,

      keyboardType: keyboardType,

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),

        prefixIcon: Icon(icon, color: const Color(0xFFF28C28)),

        filled: true,

        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: const BorderSide(color: Color(0xFFF28C28), width: 1.5),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  // ==================================================
  // BOTTOM NAVIGATION
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
