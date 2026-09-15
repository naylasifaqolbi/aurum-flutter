import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // ==========================================
  // REGISTER
  // ==========================================
  Future<void> _register() async {
    // Menjalankan semua validator.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Sampai sini berarti semua field sudah terisi
    // dan password sudah sesuai.

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        emailRedirectTo: 'com.example.aurum://login-callback/',
        data: {
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
        },
      );

      if (!mounted) return;

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registrasi berhasil. Silakan cek email untuk verifikasi akun.',
            ),
          ),
        );

        // Karena konfirmasi email aktif,
        // user perlu verifikasi email sebelum login.
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        });
      }
    } on AuthException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan. Silakan coba lagi.')),
      );
    }
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
      resizeToAvoidBottomInset: false,

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
                    // NAMA
                    // ==========================================
                    const Text(
                      'Nama',

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _nameController,

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama wajib diisi';
                        }

                        return null;
                      },

                      decoration: _inputDecoration(
                        hintText: 'Masukkan nama',
                        prefixIcon: Icons.person_outline,
                      ),
                    ),

                    const SizedBox(height: 18),

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
