class ProfileModel {
  final String nama;
  final String email;
  final String phone;
  final String? avatarUrl;

  const ProfileModel({
    this.nama = '-',
    this.email = '-',
    this.phone = '-',
    this.avatarUrl,
  });

  ProfileModel copyWith({
    String? nama,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    return ProfileModel(
      nama: nama ?? this.nama,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
