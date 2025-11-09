class UserInterestModel {
  final int id;
  final int userProfileId;
  final int subjectId;

  UserInterestModel({
    required this.id,
    required this.userProfileId,
    required this.subjectId,
  });

  factory UserInterestModel.fromJson(Map<String, dynamic> json) {
    return UserInterestModel(
      id: json['id'] as int,
      userProfileId: json['user_profile_id'] as int,
      subjectId: json['subject_id'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_profile_id': userProfileId,
    'subject_id': subjectId,
  };
}
