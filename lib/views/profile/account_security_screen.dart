import 'package:flutter/material.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  final TextEditingController _currentPasswordController =
      TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _ubahPassword() {
    if (_currentPasswordController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua data wajib diisi.')));

      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak sesuai.')),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password berhasil diperbarui.')),
    );
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
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF3D2B1F),
            size: 25,
          ),
        ),

        title: const Text(
          'Ubah Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF28C28),
          ),
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==========================================
              // ICON
              // ==========================================
              Center(
                child: Container(
                  width: 56,
                  height: 56,

                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE5CC),
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 27,
                    color: Color(0xFFF28C28),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ==========================================
              // JUDUL
              // ==========================================
              const Center(
                child: Text(
                  'Buat Password Baru',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const Center(
                child: Text(
                  'Gunakan password yang kuat untuk menjaga keamanan\nakun Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF777777),
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ==========================================
              // FORM CARD
              // ==========================================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: const Color(0xFFE8DDD4)),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ======================================
                    // PASSWORD SAAT INI
                    // ======================================
                    _buildPasswordLabel('Password Saat Ini'),

                    const SizedBox(height: 6),

                    _buildPasswordField(
                      controller: _currentPasswordController,
                      hintText: 'Masukkan password saat ini',
                      obscureText: !_showCurrentPassword,
                      onToggle: () {
                        setState(() {
                          _showCurrentPassword = !_showCurrentPassword;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // ======================================
                    // PASSWORD BARU
                    // ======================================
                    _buildPasswordLabel('Password Baru'),

                    const SizedBox(height: 6),

                    _buildPasswordField(
                      controller: _passwordController,
                      hintText: 'Masukkan password baru',
                      obscureText: !_showNewPassword,
                      onToggle: () {
                        setState(() {
                          _showNewPassword = !_showNewPassword;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // ======================================
                    // KONFIRMASI PASSWORD BARU
                    // ======================================
                    _buildPasswordLabel('Konfirmasi Password Baru'),

                    const SizedBox(height: 6),

                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      hintText: 'Konfirmasi password baru',
                      obscureText: !_showConfirmPassword,
                      onToggle: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ==========================================
              // PASSWORD REQUIREMENTS
              // ==========================================
              const Text(
                'Password harus memiliki:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                ),
              ),

              const SizedBox(height: 8),

              _buildRequirement(
                icon: Icons.check_rounded,
                iconColor: Colors.green,
                backgroundColor: const Color(0xFFE5F7EF),
                text: 'Minimal 8 karakter',
              ),

              const SizedBox(height: 7),

              _buildRequirement(
                icon: Icons.circle,
                iconColor: Color(0xFFF28C28),
                backgroundColor: Color(0xFFFFF3E7),
                text: 'Mengandung huruf dan angka',
              ),

              const SizedBox(height: 46),

              // ==========================================
              // SIMPAN PASSWORD
              // ==========================================
              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: _ubahPassword,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF28C28),
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Simpan Password',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
  // PASSWORD LABEL
  // ==================================================

  Widget _buildPasswordLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF222222),
      ),
    );
  }

  // ==================================================
  // PASSWORD FIELD
  // ==================================================

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),

        suffixIcon: IconButton(
          onPressed: onToggle,

          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: const Color(0xFF777777),
            size: 21,
          ),
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: Color(0xFFE8DDD4)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: Color(0xFFE8DDD4)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: Color(0xFFF28C28), width: 1.5),
        ),
      ),
    );
  }

  // ==================================================
  // PASSWORD REQUIREMENT
  // ==================================================

  Widget _buildRequirement({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,

          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),

          child: Icon(icon, size: 10, color: iconColor),
        ),

        const SizedBox(width: 8),

        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Color(0xFF777777)),
        ),
      ],
    );
  }
}
