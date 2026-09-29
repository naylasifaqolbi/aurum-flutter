import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileModel _profile = const ProfileModel();

  ProfileModel get profile => _profile;

  String get nama => _profile.nama;
  String get email => _profile.email;
  String get phone => _profile.phone;
  String? get avatarUrl => _profile.avatarUrl;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ==========================================
  // LOAD PROFILE DARI SUPABASE
  // ==========================================

  Future<void> loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select('name, phone, avatar_url')
          .eq('id', user.id)
          .single();

      _profile = ProfileModel(
        nama: profile['name'] ?? '-',
        phone: profile['phone'] ?? '-',
        email: user.email ?? '-',
        avatarUrl: profile['avatar_url'],
      );
    } catch (error) {
      // Jika data profile gagal diambil,
      // email tetap diambil dari user Supabase.
      _profile = _profile.copyWith(email: user.email ?? '-');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================
  // LOGOUT
  // ==========================================

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();

    print(
      'SESSION SETELAH LOGOUT: '
      '${Supabase.instance.client.auth.currentSession}',
    );
  }
}
