import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController(
    text: 'Rosalinda',
  );

  final TextEditingController _emailController = TextEditingController(
    text: 'rosalinda@email.com',
  );

  final TextEditingController _phoneController = TextEditingController(
    text: '08xxxxxxxxxx',
  );

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _simpanProfil() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 0,
        foregroundColor: const Color(0xFF3D2B1F),

        title: const Text(
          'Ubah Profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Ubah Informasi Profil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF28C28),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Perbarui informasi akun Anda.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
                ),

                const SizedBox(height: 30),

                Center(
                  child: Container(
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
                ),

                const SizedBox(height: 30),

                _buildLabel('Nama'),

                const SizedBox(height: 8),

                _buildTextField(
                  controller: _namaController,
                  hintText: 'Masukkan nama',
                  icon: Icons.person_outline_rounded,
                ),

                const SizedBox(height: 20),

                _buildLabel('Email'),

                const SizedBox(height: 8),

                _buildTextField(
                  controller: _emailController,
                  hintText: 'Masukkan email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                _buildLabel('Nomor HP'),

                const SizedBox(height: 8),

                _buildTextField(
                  controller: _phoneController,
                  hintText: 'Masukkan nomor HP',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: ElevatedButton(
                    onPressed: _simpanProfil,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF28C28),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$hintText wajib diisi';
        }

        return null;
      },

      decoration: InputDecoration(
        hintText: hintText,

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
      ),
    );
  }
}
