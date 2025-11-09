class User {
  final int id;
  final String email;
  final String login;
  final String? googleId;
  final String? appleId;
  final DateTime createdAt;
  final Profile? profile;
  final bool isNewProfile;

  const User({
    required this.id,
    required this.email,
    required this.login,
    this.googleId,
    this.appleId,
    required this.createdAt,
    this.profile,
    required this.isNewProfile,
  });
}

class Profile {
  final String? name;
  final String? ageCategory;
  final String? interestLevel;
  final String? addressCity;
  final String? sex;
  final int? userId;

  const Profile({
    this.name,
    this.ageCategory,
    this.interestLevel,
    this.addressCity,
    this.sex,
    this.userId,
  });
}

