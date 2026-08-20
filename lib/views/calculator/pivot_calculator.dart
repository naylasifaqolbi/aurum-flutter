import 'package:flutter/material.dart';

class PivotCalculator extends StatefulWidget {
  const PivotCalculator({super.key});

  @override
  State<PivotCalculator> createState() => _PivotCalculatorState();
}

class _PivotCalculatorState extends State<PivotCalculator> {
  // ==================================================
  // CONTROLLER INPUT
  // ==================================================

  final TextEditingController _highController = TextEditingController();

  final TextEditingController _lowController = TextEditingController();

  final TextEditingController _closeController = TextEditingController();

  @override
  void dispose() {
    _highController.dispose();
    _lowController.dispose();
    _closeController.dispose();

    super.dispose();
  }

  // ==================================================
  // TOMBOL HITUNG
  // ==================================================

  void _hitung() {
    // Perhitungan Pivot Point akan dibuat
    // pada tahap berikutnya.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Perhitungan Pivot Point akan dibuat pada tahap berikutnya.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

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

              const SizedBox(height: 35),

              // ==========================================
              // TITLE
              // ==========================================
              const Text(
                'Pivot Point',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF28C28),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Masukkan harga High, Low, dan Close '
                'untuk menghitung Pivot Point.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777777),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // ==========================================
              // HARGA HIGH
              // ==========================================
              _buildInputLabel('Harga High'),

              const SizedBox(height: 8),

              _buildInputField(
                controller: _highController,
                hintText: 'Masukkan harga high',
                icon: Icons.arrow_upward_rounded,
              ),

              const SizedBox(height: 20),

              // ==========================================
              // HARGA LOW
              // ==========================================
              _buildInputLabel('Harga Low'),

              const SizedBox(height: 8),

              _buildInputField(
                controller: _lowController,
                hintText: 'Masukkan harga low',
                icon: Icons.arrow_downward_rounded,
              ),

              const SizedBox(height: 20),

              // ==========================================
              // HARGA CLOSE
              // ==========================================
              _buildInputLabel('Harga Close'),

              const SizedBox(height: 8),

              _buildInputField(
                controller: _closeController,
                hintText: 'Masukkan harga close',
                icon: Icons.show_chart_rounded,
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
  }) {
    return TextField(
      controller: controller,

      keyboardType: const TextInputType.numberWithOptions(decimal: true),

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
}
