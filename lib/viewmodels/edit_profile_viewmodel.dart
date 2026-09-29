import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/edit_profile_model.dart';

class EditProfileViewModel extends ChangeNotifier {
  // ==================================================
  // MODEL
  // ==================================================

  EditProfileModel _profile = const EditProfileModel();

  EditProfileModel get profile => _profile;

  String get nama => _profile.nama;

  String get email => _profile.email;

  String get phone => _profile.phone;

  String? get avatarUrl => _profile.avatarUrl;

  // ==================================================
  // FOTO
  // ==================================================

  XFile? _imageFile;

  XFile? get imageFile => _imageFile;

  // ==================================================
  // LOADING
  // ==================================================

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ==================================================
  // ERROR MESSAGE
  // ==================================================

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // ==================================================
  // LOAD PROFILE
  // ==================================================

  Future<void> loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final profileData = await Supabase.instance.client
          .from('profiles')
          .select('name, phone, avatar_url')
          .eq('id', user.id)
          .single();

      _profile = EditProfileModel(
        nama: profileData['name'] ?? '',
        email: user.email ?? '',
        phone: profileData['phone'] ?? '',
        avatarUrl: profileData['avatar_url'] ?? '',
      );
    } catch (_) {
      // Jika data profile gagal diambil,
      // email tetap diambil dari user authentication.
      _profile = _profile.copyWith(email: user.email ?? '');
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ==================================================
  // PILIH FOTO
  // ==================================================

  Future<void> pilihFoto(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile == null) {
      return;
    }

    _imageFile = pickedFile;

    _errorMessage = null;

    notifyListeners();
  }

  // ==================================================
  // SIMPAN PROFIL
  // ==================================================

  Future<bool> simpanProfil({
    required String nama,
    required String phone,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      _errorMessage = 'User tidak ditemukan.';

      notifyListeners();

      return false;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      String? avatarUrl;

      // ==================================================
      // UPLOAD FOTO JIKA ADA FOTO BARU
      // ==================================================

      if (_imageFile != null) {
        final File file = File(_imageFile!.path);

        final String extension = _imageFile!.path.split('.').last.toLowerCase();

        final String filePath = '${user.id}/avatar.$extension';

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

      // ==================================================
      // DATA YANG AKAN DIUPDATE
      // ==================================================

      final Map<String, dynamic> updateData = {
        'name': nama.trim(),
        'phone': phone.trim(),
      };

      // Hanya update avatar_url jika user memilih
      // foto baru.
      if (avatarUrl != null) {
        updateData['avatar_url'] = avatarUrl;
      }

      // ==================================================
      // UPDATE DATABASE
      // ==================================================

      await Supabase.instance.client
          .from('profiles')
          .update(updateData)
          .eq('id', user.id);

      // ==================================================
      // UPDATE DATA LOCAL VIEWMODEL
      // ==================================================

      _profile = EditProfileModel(
        nama: nama.trim(),
        email: user.email ?? '',
        phone: phone.trim(),
        avatarUrl: avatarUrl ?? _profile.avatarUrl,
      );

      // Foto baru sudah berhasil disimpan.
      _imageFile = null;

      return true;
    }
    // ==================================================
    // ERROR STORAGE SUPABASE
    // ==================================================
    on StorageException catch (error) {
      _errorMessage = 'Gagal mengunggah foto: ${error.message}';

      return false;
    }
    // ==================================================
    // ERROR DATABASE SUPABASE
    // ==================================================
    on PostgrestException catch (error) {
      _errorMessage = error.message;

      return false;
    }
    // ==================================================
    // ERROR LAINNYA
    // ==================================================
    catch (_) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';

      return false;
    }
    // ==================================================
    // SELESAI
    // ==================================================
    finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}
