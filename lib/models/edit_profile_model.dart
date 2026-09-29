class EditProfileModel {
  final String nama;
  final String email;
  final String phone;
  final String? avatarUrl;

  const EditProfileModel({
    this.nama = '',
    this.email = '',
    this.phone = '',
    this.avatarUrl,
  });

  EditProfileModel copyWith({
    String? nama,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    return EditProfileModel(
      nama: nama ?? this.nama,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
