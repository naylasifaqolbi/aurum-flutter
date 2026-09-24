import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ==========================================
  // UPDATE PASSWORD
  // ==========================================
  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passwordController.text),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diubah.')),
      );

      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;

      Navigator.popUntil(context, (route) => route.isFirst);
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

      // ==================================================
      // HEADER
      // ==================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
        ),

        leading: IconButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF3D2B1F),
            size: 25,
          ),
        ),

        title: const Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF28C28),
          ),
        ),
      ),

      // ==================================================
      // BODY
      // ==================================================
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // ICON
                // ==================================================
                Center(
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5CC),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      size: 44,
                      color: Color(0xFFF28C28),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ==================================================
                // TITLE
                // ==================================================
                const Text(
                  'Buat Password Baru',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D2B1F),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Buat password baru untuk mengamankan kembali '
                  'akun AURUM kamu.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF777777),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // ==================================================
                // LABEL PASSWORD BARU
                // ==================================================
                const Text(
                  'Password Baru',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),

                const SizedBox(height: 8),

                // ==================================================
                // PASSWORD BARU
                // ==================================================
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Masukkan password baru',
                    hintStyle: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 14,
                    ),

                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: Color(0xFFF28C28),
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF777777),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),

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
                      borderSide: const BorderSide(
                        color: Color(0xFFF28C28),
                        width: 1.5,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.red),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password wajib diisi';
                    }

                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ==================================================
                // LABEL KONFIRMASI PASSWORD
                // ==================================================
                const Text(
                  'Konfirmasi Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),

                const SizedBox(height: 8),

                // ==================================================
                // KONFIRMASI PASSWORD
                // ==================================================
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Masukkan ulang password',
                    hintStyle: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 14,
                    ),

                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: Color(0xFFF28C28),
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF777777),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),

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
                      borderSide: const BorderSide(
                        color: Color(0xFFF28C28),
                        width: 1.5,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.red),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password wajib diisi';
                    }

                    if (value != _passwordController.text) {
                      return 'Password tidak sama';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // ==================================================
                // BUTTON SIMPAN
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updatePassword,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF28C28),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFF8B66A),
                      disabledForegroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
