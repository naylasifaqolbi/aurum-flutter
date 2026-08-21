import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 0,
        foregroundColor: const Color(0xFF3D2B1F),

        title: const Text(
          'Bantuan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Pusat Bantuan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF28C28),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Temukan informasi dan bantuan penggunaan Aurum.',
                style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
              ),

              const SizedBox(height: 25),

              _buildHelpItem(
                icon: Icons.calculate_outlined,
                title: 'Cara Menggunakan Kalkulator',
                description:
                    'Masukkan data yang diperlukan kemudian tekan tombol Hitung.',
              ),

              _buildHelpItem(
                icon: Icons.history_rounded,
                title: 'Riwayat Perhitungan',
                description:
                    'Anda dapat melihat kembali hasil perhitungan yang telah dilakukan.',
              ),

              _buildHelpItem(
                icon: Icons.person_outline_rounded,
                title: 'Pengelolaan Profil',
                description:
                    'Gunakan menu Ubah Profil untuk memperbarui informasi akun.',
              ),

              _buildHelpItem(
                icon: Icons.support_agent_outlined,
                title: 'Hubungi Bantuan',
                description:
                    'Jika mengalami kendala, silakan hubungi pihak terkait.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
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
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: const Color(0xFFFFE5CC),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: const Color(0xFFF28C28)),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D2B1F),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF777777),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
