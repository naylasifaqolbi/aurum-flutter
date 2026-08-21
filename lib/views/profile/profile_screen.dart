import 'package:flutter/material.dart';

import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';
import 'app_settings_screen.dart';
import 'help_screen.dart';
import 'account_security_screen.dart';

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
                'Kelola informasi dan pengaturan akun Aurum Anda.',
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
                    // FOTO PROFIL
                    Container(
                      width: 90,
                      height: 90,

                      decoration: const BoxDecoration(
                        color: Color(0xFFFFE5CC),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.person_rounded,
                        size: 48,
                        color: Color(0xFFF28C28),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // NAMA
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

              const SizedBox(height: 25),

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
              // PENGATURAN
              // ==========================================
              const Text(
                'Pengaturan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D2B1F),
                ),
              ),

              const SizedBox(height: 15),

              // ==========================================
              // MENU
              // ==========================================
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
                    // ======================================
                    // UBAH PROFIL
                    // ======================================
                    _buildMenuItem(
                      icon: Icons.edit_outlined,
                      title: 'Ubah Profil',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    // ======================================
                    // PENGATURAN APLIKASI
                    // ======================================
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Pengaturan Aplikasi',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppSettingsScreen(),
                          ),
                        );
                      },
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    // ======================================
                    // BANTUAN
                    // ======================================
                    _buildMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Bantuan',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpScreen(),
                          ),
                        );
                      },
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    // ======================================
                    // KEAMANAN AKUN
                    // ======================================
                    _buildMenuItem(
                      icon: Icons.security_outlined,
                      title: 'Keamanan Akun',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountSecurityScreen(),
                          ),
                        );
                      },
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    // ======================================
                    // KELUAR
                    // ======================================
                    _buildMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'Keluar',
                      iconColor: Colors.red,
                      titleColor: Colors.red,
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
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

  // ==================================================
  // MENU ITEM
  // ==================================================

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFFF28C28),
    Color titleColor = const Color(0xFF3D2B1F),
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(20),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,

                decoration: BoxDecoration(
                  color: iconColor == Colors.red
                      ? Colors.red.withOpacity(0.08)
                      : const Color(0xFFFFE5CC),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(icon, size: 22, color: iconColor),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: iconColor == Colors.red
                    ? Colors.red.withOpacity(0.7)
                    : const Color(0xFFAAAAAA),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // LOGOUT DIALOG
  // ==================================================

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            'Keluar dari Akun?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D2B1F),
            ),
          ),

          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun Aurum?',
            style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Batal',
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}
