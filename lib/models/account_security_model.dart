class AccountSecurityModel {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const AccountSecurityModel({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
  });

  AccountSecurityModel copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  }) {
    return AccountSecurityModel(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
