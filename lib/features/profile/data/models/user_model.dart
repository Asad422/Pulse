import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.login,
    super.googleId,
    super.appleId,
    required super.createdAt,
    super.profile,
    required super.isNewProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;
    final profileJson = json['profile'] as Map<String, dynamic>?;

    // если объект user отсутствует — безопасная подстановка
    return UserModel(
      id: userJson?['id'] as int? ?? 0,
      email: userJson?['email'] as String? ?? '',
      login: userJson?['login'] as String? ?? '',
      googleId: userJson?['google_id'] as String?,
      appleId: userJson?['apple_id'] as String?,
      createdAt: userJson?['created_at'] != null
          ? DateTime.tryParse(userJson!['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      profile: profileJson != null
          ? ProfileModel.fromJson(profileJson)
          : null,
      isNewProfile: json['is_new_profile'] as bool? ?? false,
    );
  }
}

class ProfileModel extends Profile {
  const ProfileModel({
    super.name,
    super.ageCategory,
    super.interestLevel,
    super.addressCity,
    super.userId,
    super.sex,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] as String?,
      ageCategory: json['age_category'] as String?,
      interestLevel: json['interest_level'] as String?,
      addressCity: json['address_city'] as String?,
      userId: json['user_id'] as int?,
      sex: json['sex'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'age_category': ageCategory,
    'interest_level': interestLevel,
    'address_city': addressCity,
    'sex': sex,
  };
}
