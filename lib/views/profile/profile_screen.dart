import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';
import 'app_settings_screen.dart';
import 'help_screen.dart';
import 'account_security_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nama = '-';
  String _email = '-';
  String _phone = '-';
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ==========================================
  // LOAD PROFILE DARI SUPABASE
  // ==========================================
  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    try {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select('name, phone, avatar_url')
          .eq('id', user.id)
          .single();

      if (!mounted) return;

      setState(() {
        _nama = profile['name'] ?? '-';
        _phone = profile['phone'] ?? '-';
        _email = user.email ?? '-';
        _avatarUrl = profile['avatar_url'];
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _email = user.email ?? '-';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      // ==========================================
      // HEADER
      // ==========================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 64,
        titleSpacing: 20,

        title: Row(
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
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==========================================
              // PROFILE CARD
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(color: const Color(0xFFF28C28), width: 1),
                ),

                child: Row(
                  children: [
                    // ======================================
                    // FOTO PROFIL
                    // ======================================
                    Stack(
                      clipBehavior: Clip.none,

                      children: [
                        Container(
                          width: 64,
                          height: 64,

                          decoration: const BoxDecoration(
                            color: Color(0xFFFFE5CC),
                            shape: BoxShape.circle,
                          ),

                          child: _avatarUrl != null && _avatarUrl!.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                     '${_avatarUrl!}?t=${DateTime.now().millisecondsSinceEpoch}',
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.person_rounded,
                                  size: 38,
                                  color: Color(0xFFF28C28),
                                ),
                        ),

                        Positioned(
                          right: -2,
                          bottom: -2,

                          child: Container(
                            width: 24,
                            height: 24,

                            decoration: const BoxDecoration(
                              color: Color(0xFF3D2B1F),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // ======================================
                    // NAMA + EMAIL
                    // ======================================
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            _nama,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3D2B1F),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            _email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ==========================================
              // AKUN
              // ==========================================
              const Text(
                'AKUN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAAAAAA),
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    // ======================================
                    // EDIT PROFIL
                    // ======================================
                    _buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Profil',
                      subtitle: 'Ubah informasi profil Anda',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );

                        _loadProfile();
                      },
                    ),

                    const Divider(height: 1, indent: 60, endIndent: 0),

                    // ======================================
                    // UBAH PASSWORD
                    // ======================================
                    _buildMenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Ubah Password',
                      subtitle: 'Ganti password akun Anda',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountSecurityScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ==========================================
              // PENGATURAN
              // ==========================================
              const Text(
                'PENGATURAN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAAAAAA),
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    // ======================================
                    // BAHASA
                    // ======================================
                    _buildMenuItem(
                      icon: Icons.language_rounded,
                      title: 'Bahasa',
                      subtitle: 'Bahasa Indonesia',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppSettingsScreen(),
                          ),
                        );
                      },
                    ),

                    const Divider(height: 1, indent: 60, endIndent: 0),

                    // ======================================
                    // TEMA
                    // ======================================
                    _buildMenuItem(
                      icon: Icons.palette_outlined,
                      title: 'Tema',
                      subtitle: 'Terang',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppSettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ==========================================
              // TENTANG
              // ==========================================
              const Text(
                'TENTANG',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAAAAAA),
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: _buildMenuItem(
                  icon: Icons.info_outline_rounded,
                  title: 'Tentang AURUM',
                  subtitle: 'Informasi aplikasi',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              // ==========================================
              // KELUAR
              // ==========================================
              SizedBox(
                width: double.infinity,
                height: 56,

                child: OutlinedButton.icon(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },

                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 21,
                  ),

                  label: const Text(
                    'Keluar',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),

                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,

                    padding: const EdgeInsets.symmetric(horizontal: 18),

                    side: const BorderSide(color: Color(0xFFE8B9A9)),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // MENU ITEM
  // ==================================================

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(16),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),

          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,

                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E7),
                  borderRadius: BorderRadius.circular(11),
                ),

                child: Icon(icon, size: 20, color: const Color(0xFFF28C28)),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      subtitle,

                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: Color(0xFFAAAAAA),
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
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();

                print(
                  'SESSION SETELAH LOGOUT: ${Supabase.instance.client.auth.currentSession}',
                );

                if (!context.mounted) return;

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
