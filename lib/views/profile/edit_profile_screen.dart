import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  XFile? _imageFile;
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
        _namaController.text = profile['name'] ?? '';
        _phoneController.text = profile['phone'] ?? '';
        _emailController.text = user.email ?? '';
        _avatarUrl = profile['avatar_url'] ?? '';
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _emailController.text = user.email ?? '';
      });
    }
  }

  // ==========================================
  // PILIH FOTO PROFIL
  // ==========================================
  Future<void> _pilihFoto(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    if (!mounted) return;

    setState(() {
      _imageFile = pickedFile;
    });
  }

  // ==========================================
  // PILIH SUMBER FOTO
  // ==========================================
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pilih Foto Profil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D2B1F),
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_rounded,
                    color: Color(0xFFF28C28),
                  ),
                  title: const Text('Kamera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pilihFoto(ImageSource.camera);
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.photo_library_rounded,
                    color: Color(0xFFF28C28),
                  ),
                  title: const Text('Galeri'),
                  onTap: () {
                    Navigator.pop(context);
                    _pilihFoto(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _simpanProfil() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    try {
      String? avatarUrl;

      // ==========================================
      // UPLOAD FOTO PROFIL
      // ==========================================
      if (_imageFile != null) {
        final file = File(_imageFile!.path);

        final extension = _imageFile!.path.split('.').last.toLowerCase();

        final filePath = '${user.id}/avatar.$extension';

        await Supabase.instance.client.storage
            .from('profile-avatars')
            .upload(
              filePath,
              file,
              fileOptions: const FileOptions(upsert: true),
            );

        avatarUrl = Supabase.instance.client.storage
            .from('profile-avatars')
            .getPublicUrl(filePath);
      }

      // ==========================================
      // SIMPAN DATA PROFIL
      // ==========================================
      final updateData = {
        'name': _namaController.text.trim(),
        'phone': _phoneController.text.trim(),
      };

      if (avatarUrl != null) {
        updateData['avatar_url'] = avatarUrl;
      }

      await Supabase.instance.client
          .from('profiles')
          .update(updateData)
          .eq('id', user.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui.')),
      );

      Navigator.pop(context);
    } on StorageException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah foto: ${error.message}')),
      );
    } on PostgrestException catch (error) {
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
          'Edit Profil',
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

          padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ==========================================
                // FOTO PROFIL
                // ==========================================
                Center(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,

                        children: [
                          // FOTO
                          GestureDetector(
                            onTap: _showPhotoOptions,

                            child: Container(
                              width: 96,
                              height: 96,

                              decoration: const BoxDecoration(
                                color: Color(0xFFFFE5CC),
                                shape: BoxShape.circle,
                              ),

                              child: _imageFile != null
                                  ? ClipOval(
                                      child: Image.file(
                                        File(_imageFile!.path),
                                        width: 96,
                                        height: 96,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : _avatarUrl != null && _avatarUrl!.isNotEmpty
                                  ? ClipOval(
                                      child: Image.network(
                                        '${_avatarUrl!}?t=${DateTime.now().millisecondsSinceEpoch}',
                                        width: 96,
                                        height: 96,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person_rounded,
                                      size: 52,
                                      color: Color(0xFFF28C28),
                                    ),
                            ),
                          ),

                          // TOMBOL KAMERA
                          Positioned(
                            right: -2,
                            bottom: -2,

                            child: GestureDetector(
                              onTap: _showPhotoOptions,

                              child: Container(
                                width: 30,
                                height: 30,

                                decoration: const BoxDecoration(
                                  color: Color(0xFF3D2B1F),
                                  shape: BoxShape.circle,
                                ),

                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Ubah Foto',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF28C28),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ==========================================
                // FORM CARD
                // ==========================================
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(18),

                    border: Border.all(color: const Color(0xFFE8DDD4)),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // ======================================
                      // NAMA
                      // ======================================
                      _buildLabel('Nama Lengkap'),

                      const SizedBox(height: 8),

                      _buildTextField(
                        controller: _namaController,
                        hintText: 'Masukkan nama',
                        icon: Icons.person_outline_rounded,
                      ),

                      const SizedBox(height: 20),

                      // ======================================
                      // EMAIL
                      // ======================================
                      _buildLabel('Email'),

                      const SizedBox(height: 8),

                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true,
                      ),

                      const SizedBox(height: 20),

                      // ======================================
                      // NOMOR TELEPON
                      // ======================================
                      _buildLabel('Nomor Telepon'),

                      const SizedBox(height: 8),

                      _buildTextField(
                        controller: _phoneController,
                        hintText: 'Masukkan nomor telepon',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ==========================================
                // SIMPAN PERUBAHAN
                // ==========================================
                SizedBox(
                  width: double.infinity,
                  height: 52,

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
      ),
    );
  }

  // ==================================================
  // LABEL
  // ==================================================

  Widget _buildLabel(String label) {
    return Text(
      label,

      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF666666),
      ),
    );
  }

  // ==================================================
  // TEXT FIELD
  // ==================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,

      readOnly: readOnly,

      keyboardType: keyboardType,

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$hintText wajib diisi';
        }

        return null;
      },

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF999999)),

        prefixIcon: Icon(icon, color: const Color(0xFFF28C28), size: 21),

        filled: true,

        fillColor: readOnly ? const Color(0xFFF8F8F8) : Colors.white,

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

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
      ),
    );
  }
}
