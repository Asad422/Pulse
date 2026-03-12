import 'package:pulse/features/profile/domain/entities/age_category.dart';
import 'package:pulse/features/profile/domain/entities/sex_category.dart';
import 'package:pulse/features/profile/domain/entities/profile_enums.dart';

class ProfileEnumsModel extends ProfileEnums {
  ProfileEnumsModel({
    required List<AgeCategory> ageCategories,
    required List<SexCategory> sexCategories,
  }) : super(ageCategories: ageCategories, sexCategories: sexCategories);

  factory ProfileEnumsModel.fromJson(Map<String, dynamic> json) {
    final ageList = json['age_category'] as List<dynamic>? ?? [];
    final sexList = json['sex'] as List<dynamic>? ?? [];

    return ProfileEnumsModel(
      ageCategories: ageList
          .map((e) => AgeCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sexCategories: sexList
          .map((e) => SexCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AgeCategoryModel extends AgeCategory {
  AgeCategoryModel({required super.label, required super.value});

  factory AgeCategoryModel.fromJson(Map<String, dynamic> json) {
    return AgeCategoryModel(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }
}

class SexCategoryModel extends SexCategory {
  SexCategoryModel({required super.label, required super.value});

  factory SexCategoryModel.fromJson(Map<String, dynamic> json) {
    return SexCategoryModel(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }
}

