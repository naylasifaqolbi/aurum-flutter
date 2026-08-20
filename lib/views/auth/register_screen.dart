import 'package:flutter/material.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // ==========================================
  // REGISTER
  // ==========================================
  void _register() {
    // Menjalankan semua validator.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Sampai sini berarti semua field sudah terisi
    // dan password sudah sesuai.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registrasi berhasil. Silakan masuk ke akun Anda.'),
      ),
    );

    // Belum menyimpan ke database.
    // Setelah registrasi berhasil, kembali ke Login.
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  // ==========================================
  // KE LOGIN
  // ==========================================
  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // ==========================================
  // INPUT DECORATION
  // ==========================================
  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,

      hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),

      prefixIcon: Icon(prefixIcon, color: const Color(0xFFF28C28)),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: const Color(0xFFFFFAF5),

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

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          // ==========================================
          // FOOTER
          // ==========================================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,

            child: IgnorePointer(
              child: Align(
                alignment: Alignment.bottomCenter,

                child: Image.asset(
                  'assets/images/footer_dash.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),

          // ==========================================
          // CONTENT
          // ==========================================
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ==========================================
                    // LOGO
                    // ==========================================
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 130,
                        height: 130,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==========================================
                    // TITLE
                    // ==========================================
                    const Center(
                      child: Text(
                        'Buat Akun Anda',
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ==========================================
                    // DESCRIPTION
                    // ==========================================
                    const Center(
                      child: Text(
                        'Daftarkan akun Anda untuk mulai menggunakan\n'
                        'aplikasi Aurum.',
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF777777),
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ==========================================
                    // EMAIL
                    // ==========================================
                    const Text(
                      'Email',

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email wajib diisi';
                        }

                        return null;
                      },

                      decoration: _inputDecoration(
                        hintText: 'Masukkan email',
                        prefixIcon: Icons.email_outlined,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==========================================
                    // NOMOR TELEPON
                    // ==========================================
                    const Text(
                      'Nomor Telepon',

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nomor telepon wajib diisi';
                        }

                        return null;
                      },

                      decoration: _inputDecoration(
                        hintText: 'Masukkan nomor telepon',
                        prefixIcon: Icons.phone_outlined,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==========================================
                    // PASSWORD
                    // ==========================================
                    const Text(
                      'Password',

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password wajib diisi';
                        }

                        return null;
                      },

                      decoration: _inputDecoration(
                        hintText: 'Masukkan password',
                        prefixIcon: Icons.lock_outline,

                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },

                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,

                            color: const Color(0xFF888888),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==========================================
                    // KONFIRMASI PASSWORD
                    // ==========================================
                    const Text(
                      'Konfirmasi Password',

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password wajib diisi';
                        }

                        if (value != _passwordController.text) {
                          return 'Konfirmasi password tidak sesuai';
                        }

                        return null;
                      },

                      decoration: _inputDecoration(
                        hintText: 'Konfirmasi password Anda',
                        prefixIcon: Icons.lock_outline,

                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },

                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,

                            color: const Color(0xFF888888),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ==========================================
                    // BUTTON DAFTAR AKUN
                    // ==========================================
                    SizedBox(
                      width: double.infinity,
                      height: 52,

                      child: ElevatedButton(
                        onPressed: _register,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF28C28),
                          foregroundColor: Colors.white,
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: const Text(
                          'Daftar Akun',

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==========================================
                    // KEMBALI KE LOGIN
                    // ==========================================
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,

                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF555555),
                          ),

                          children: [
                            const TextSpan(text: 'Sudah memiliki akun? '),

                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,

                              child: GestureDetector(
                                onTap: _goToLogin,

                                child: const Text(
                                  'Masuk Disini',

                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFF28C28),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
