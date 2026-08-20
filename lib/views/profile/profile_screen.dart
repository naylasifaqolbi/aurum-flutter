import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==========================================
              // HEADER
              // ==========================================
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
                'Profil',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF28C28),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Halaman profil pengguna Aurum.',
                style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
              ),

              const SizedBox(height: 30),

              // ==========================================
              // PROFILE CARD
              // ==========================================
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

                child: Column(
                  children: [
                    // ======================================
                    // FOTO PROFIL
                    // ======================================
                    Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE5CC),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.person_rounded,
                        size: 48,
                        color: Color(0xFFF28C28),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ======================================
                    // NAMA
                    // ======================================
                    const Text(
                      'Rosalinda',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D2B1F),
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Pengguna Aurum',
                      style: TextStyle(fontSize: 13, color: Color(0xFF777777)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==========================================
              // INFORMASI AKUN
              // ==========================================
              const Text(
                'Informasi Akun',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D2B1F),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,

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

                child: Column(
                  children: [
                    _buildProfileItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Nama',
                      value: 'Rosalinda',
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    _buildProfileItem(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: 'rosalinda@email.com',
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    _buildProfileItem(
                      icon: Icons.phone_outlined,
                      title: 'Nomor HP',
                      value: '08xxxxxxxxxx',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==========================================
              // BUTTON EDIT PROFIL
              // ==========================================
              SizedBox(
                width: double.infinity,
                height: 52,

                child: OutlinedButton(
                  onPressed: () {
                    // Fitur edit profil akan dibuat nanti.
                  },

                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF28C28),

                    side: const BorderSide(color: Color(0xFFF28C28)),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Edit Profil',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==========================================
              // BUTTON LOGOUT
              // ==========================================
              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: () {
                    // Fitur logout akan dibuat nanti.
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    elevation: 0,

                    side: const BorderSide(color: Colors.redAccent),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
  // PROFILE ITEM
  // ==================================================

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: const Color(0xFFFFE5CC),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: const Color(0xFFF28C28), size: 22),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3D2B1F),
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
