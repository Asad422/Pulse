import 'package:pulse/features/profile/domain/entities/age_category.dart';
import 'package:pulse/features/profile/domain/entities/sex_category.dart';

class ProfileEnums {
  final List<AgeCategory> ageCategories;
  final List<SexCategory> sexCategories;
  ProfileEnums({required this.ageCategories, required this.sexCategories});
}