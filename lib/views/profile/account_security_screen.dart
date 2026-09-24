import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  bool get _hasMinLength => _passwordController.text.length >= 6;

  bool get _hasLetter => RegExp(r'[A-Za-z]').hasMatch(_passwordController.text);

  bool get _hasNumber => RegExp(r'\d').hasMatch(_passwordController.text);

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

  Future<void> _ubahPassword() async {
    // ==========================================
    // VALIDASI FIELD WAJIB
    // ==========================================

    if (_currentPasswordController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua data wajib diisi.')));

      return;
    }

    // ==========================================
    // VALIDASI PASSWORD BARU
    // ==========================================

    if (!_hasMinLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password baru minimal 6 karakter.')),
      );

      return;
    }

    if (!_hasLetter) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password baru harus mengandung huruf.')),
      );

      return;
    }

    if (!_hasNumber) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password baru harus mengandung angka.')),
      );

      return;
    }

    // ==========================================
    // VALIDASI KONFIRMASI PASSWORD
    // ==========================================

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak sesuai.')),
      );

      return;
    }

    // ==========================================
    // UPDATE PASSWORD SUPABASE
    // ==========================================
    setState(() {
      _isLoading = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null || user.email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi login tidak ditemukan. Silakan login kembali.'),
          ),
        );

        return;
      }

      // ==========================================
      // SIMPAN PASSWORD BARU
      // ==========================================

      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          password: _passwordController.text,
          currentPassword: _currentPasswordController.text,
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diperbarui.')),
      );

      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;

      Navigator.pop(context);
    } on AuthException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message), backgroundColor: Colors.red),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
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
                      onChanged: (_) {
                        setState(() {});
                      },
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
                isValid: _hasMinLength,
                text: 'Minimal 6 karakter',
              ),

              const SizedBox(height: 7),

              _buildRequirement(isValid: _hasLetter, text: 'Mengandung huruf'),

              const SizedBox(height: 7),

              _buildRequirement(isValid: _hasNumber, text: 'Mengandung angka'),
              const SizedBox(height: 46),

              // ==========================================
              // SIMPAN PASSWORD
              // ==========================================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _ubahPassword,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF28C28),
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Simpan Password',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,

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

  Widget _buildRequirement({required bool isValid, required String text}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isValid ? const Color(0xFFE5F7EF) : const Color(0xFFFFF3E7),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isValid ? Icons.check_rounded : Icons.circle,
            size: 10,
            color: isValid ? Colors.green : const Color(0xFFF28C28),
          ),
        ),

        const SizedBox(width: 8),

        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isValid ? const Color(0xFF555555) : const Color(0xFF777777),
          ),
        ),
      ],
    );
  }
}
