import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/account_security_model.dart';

class AccountSecurityViewModel extends ChangeNotifier {
  // ==================================================
  // MODEL
  // ==================================================

  AccountSecurityModel _security = const AccountSecurityModel();

  AccountSecurityModel get security => _security;

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
  // PASSWORD DATA
  // ==================================================

  void setCurrentPassword(String value) {
    _security = _security.copyWith(currentPassword: value);

    notifyListeners();
  }

  void setNewPassword(String value) {
    _security = _security.copyWith(newPassword: value);

    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _security = _security.copyWith(confirmPassword: value);

    notifyListeners();
  }

  // ==================================================
  // PASSWORD VALIDATION
  // ==================================================

  bool get hasMinLength {
    return _security.newPassword.length >= 6;
  }

  bool get hasLetter {
    return RegExp(r'[A-Za-z]').hasMatch(_security.newPassword);
  }

  bool get hasNumber {
    return RegExp(r'\d').hasMatch(_security.newPassword);
  }

  // ==================================================
  // VALIDASI SEMUA FIELD
  // ==================================================

  String? validatePassword() {
    if (_security.currentPassword.trim().isEmpty ||
        _security.newPassword.trim().isEmpty ||
        _security.confirmPassword.trim().isEmpty) {
      return 'Semua data wajib diisi.';
    }

    if (!hasMinLength) {
      return 'Password baru minimal 6 karakter.';
    }

    if (!hasLetter) {
      return 'Password baru harus mengandung huruf.';
    }

    if (!hasNumber) {
      return 'Password baru harus mengandung angka.';
    }

    if (_security.newPassword != _security.confirmPassword) {
      return 'Konfirmasi password tidak sesuai.';
    }

    return null;
  }

  // ==================================================
  // UBAH PASSWORD
  // ==================================================

  Future<bool> ubahPassword() async {
    final validationMessage = validatePassword();

    if (validationMessage != null) {
      _errorMessage = validationMessage;

      notifyListeners();

      return false;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null || user.email == null) {
        _errorMessage = 'Sesi login tidak ditemukan. Silakan login kembali.';

        return false;
      }

      // ==========================================
      // UPDATE PASSWORD SUPABASE
      // ==========================================

      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          password: _security.newPassword,
          currentPassword: _security.currentPassword,
        ),
      );

      return true;
    } on AuthException catch (error) {
      _errorMessage = error.message;

      return false;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}
