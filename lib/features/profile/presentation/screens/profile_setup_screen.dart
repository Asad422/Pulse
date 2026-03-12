import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../domain/entities/user.dart';
import '../bloc/user_bloc.dart';
import '../widgets/location_dropdown.dart';
import 'interest_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String login;

  const ProfileSetupScreen({
    super.key,
    required this.login,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameCtrl = TextEditingController();
  String? _selectedState;
  bool _didSubmit = false;
  final Set<int> _interestIds = {};

  int? _ageIndex;
  int? _genderIndex;
  bool _profileHydrated = false;
  final _states = const [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming',
  ];

  String _normalize(String value) => value.trim().toLowerCase();

  int _findAgeIndex(String value, List<String> ages) {
    final normalized = _normalize(value);
    return ages.indexWhere((a) => _normalize(a) == normalized);
  }

  int _findGenderIndex(String value, List<String> genders) {
    final normalized = _normalize(value);
    const map = {
      'man': 'male',
      'male': 'male',
      'woman': 'female',
      'female': 'female',
      'non-binary': 'other',
      'nonbinary': 'other',
      'transgender': 'other',
      'other': 'other',
      'prefer_not_to_say': 'prefer_not_to_say',
    };
    final target = map[normalized] ?? normalized;
    return genders.indexWhere((g) => _normalize(g) == target);
  }

  void _hydrateProfile(UserState state) {
    if (_profileHydrated) return;
    final profile = state.user?.profile;
    if (profile == null) return;

    final ages = state.ageCategories.map((e) => e.value).toList();
    final genders = state.sexCategories.map((e) => e.value).toList();

    if ((_selectedState == null || _selectedState!.isEmpty) &&
        (profile.addressCity?.isNotEmpty ?? false)) {
      _selectedState = profile.addressCity;
    }
    if (_nameCtrl.text.isEmpty && (profile.name?.isNotEmpty ?? false)) {
      _nameCtrl.text = profile.name!;
    }
    if (_ageIndex == null && (profile.ageCategory?.isNotEmpty ?? false) && ages.isNotEmpty) {
      final idx = _findAgeIndex(profile.ageCategory!, ages);
      if (idx != -1) _ageIndex = idx;
    }
    if (_genderIndex == null && (profile.sex?.isNotEmpty ?? false) && genders.isNotEmpty) {
      final idx = _findGenderIndex(profile.sex!, genders);
      if (idx != -1) _genderIndex = idx;
    }

    final needAgeHydration = _ageIndex == null && (profile.ageCategory?.isNotEmpty ?? false);
    final needGenderHydration = _genderIndex == null && (profile.sex?.isNotEmpty ?? false);
    final canHydrateAge = !needAgeHydration || ages.isNotEmpty;
    final canHydrateGender = !needGenderHydration || genders.isNotEmpty;

    if (canHydrateAge && canHydrateGender) {
      _profileHydrated = true;
    }
  }

  void _hydrateInterests(UserState state) {
    if (state.subjects.isEmpty) return;

    final subjectIds = state.subjects.map((s) => s.id).whereType<int>().toSet();
    final interestsIds = state.interests.map((i) => i.subjectId).whereType<int>().toSet();
    Set<int> valid = interestsIds.intersection(subjectIds);

    if (valid.isEmpty) {
      final interestLevel = state.user?.profile?.interestLevel ?? '';
      if (interestLevel.isNotEmpty) {
        final names = interestLevel
            .split(',')
            .map((e) => e.trim().toLowerCase())
            .where((e) => e.isNotEmpty)
            .toSet();
        final nameToId = <String, int>{
          for (final s in state.subjects) s.name.toLowerCase(): s.id
        };
        valid = names
            .map((n) => nameToId[n])
            .whereType<int>()
            .where((id) => subjectIds.contains(id))
            .toSet();
      }
    }

    _interestIds
      ..clear()
      ..addAll(valid);
  }

  bool _isValid({required bool hasSubjects, required bool isNewProfile}) {
    final nameOk = isNewProfile ? _nameCtrl.text.trim().isNotEmpty : true;
    return nameOk &&
        _ageIndex != null &&
        _genderIndex != null &&
        (_selectedState?.isNotEmpty ?? false) &&
        (hasSubjects ? _interestIds.isNotEmpty : true);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<UserBloc>();
      final state = bloc.state;

      if (state.user == null && state.status != UserStatus.loading) {
        bloc.add(UserRequested());
      }
      if (state.subjects.isEmpty) {
        bloc.add(UserSubjectsRequested());
      }
      if (state.interests.isEmpty) {
        bloc.add(UserInterestsRequested());
      }
      if (state.ageCategories.isEmpty || state.sexCategories.isEmpty) {
        bloc.add(UserProfileEnumsRequested());
      }
    });
  }

  void _submit(BuildContext context) {
    _didSubmit = true;
    final state = context.read<UserBloc>().state;
    final existingName = state.user?.profile?.name ?? '';
    final nameToSend = (_nameCtrl.text.trim().isNotEmpty
            ? _nameCtrl.text.trim()
            : existingName)
        .trim();

    final ages = state.ageCategories;
    final genders = state.sexCategories;

    final profile = Profile(
      name: nameToSend.isEmpty ? null : nameToSend,
      ageCategory: ages[_ageIndex!].value,
      addressCity: _selectedState ?? '',
      sex: genders[_genderIndex!].value,
    );

    context.read<UserBloc>().add(
      UserUpdated(
        login: widget.login,
        profile: profile,
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (_didSubmit && state.status == UserStatus.success && state.user != null) {
          final isNewProfile = state.user?.isNewProfile ?? true;
          if (isNewProfile) {
            context.go(AppPaths.bills);
          } else {
            context.pop();
          }
        } else if (state.status == UserStatus.failure) {
          ToastService.showErrorToast(
            context,
            message: state.failure?.message ?? 'Failed to update profile',
            length: ToastLength.medium,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == UserStatus.loading;
        final subjects = state.subjects.map((s) => s.name).toList();
        final hasSubjects = subjects.isNotEmpty;
        final isNewProfile = state.user?.isNewProfile ?? true;

        _hydrateProfile(state);
        _hydrateInterests(state);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: 20.0,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Title =====
                  Text('Tell us about yourself', style: AppTextStyles.titleT2),
                  const SizedBox(height: 6),
                  Text(
                    'This helps us personalize your content and connect you with relevant issues.',
                    style: AppTextStyles.paragraphP2High
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  // ===== Name (editable for both new and existing profile) =====
                  const _SectionHeader(title: 'Name'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    style: AppTextStyles.paragraphP2,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      hintStyle: AppTextStyles.paragraphP2High
                          .copyWith(color: AppColors.textSecondary),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                            color: AppColors.surfaceContainerLow),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _DividerSection(),

                  // ===== Age Range =====
                  const _SectionHeader(title: 'Age Range'),
                  const SizedBox(height: 12),
                  if (state.ageCategories.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: List.generate(state.ageCategories.length, (i) {
                        final selected = _ageIndex == i;
                        final ageCategory = state.ageCategories[i];
                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(ageCategory.label),
                          selected: selected,
                          onSelected: (_) => setState(() => _ageIndex = i),
                          labelStyle: AppTextStyles.paragraphP2.copyWith(
                            color:
                            selected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surfaceContainerLow,
                          shape: const StadiumBorder(side: BorderSide.none),
                          side: BorderSide.none,
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 10.0),
                        );
                      }),
                    ),
                  const SizedBox(height: 24),
                  const _DividerSection(),

                  // ===== Location =====
                  const _SectionHeader(title: 'Location'),
                  const SizedBox(height: 12),
                  LocationDropdown(
                   
                    items: _states,
                    value: _selectedState,
                    onChanged: (value) {
                      setState(() => _selectedState = value);
                    },
                  ),
                  const SizedBox(height: 24),
                  const _DividerSection(),

                  // ===== Gender =====
                  const _SectionHeader(title: 'Gender'),
                  const SizedBox(height: 12),
                  if (state.sexCategories.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: List.generate(state.sexCategories.length, (i) {
                        final selected = _genderIndex == i;
                        final sexCategory = state.sexCategories[i];
                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(sexCategory.label),
                          selected: selected,
                          onSelected: (_) => setState(() => _genderIndex = i),
                          labelStyle: AppTextStyles.paragraphP2.copyWith(
                            color:
                            selected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surfaceContainerLow,
                          shape: const StadiumBorder(side: BorderSide.none),
                          side: BorderSide.none,
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 10.0),
                        );
                      }),
                    ),
                  const SizedBox(height: 24),
                  const _DividerSection(),

                  // ===== Subjects =====
                  const _SectionHeader(title: 'Key interests'),
                  const SizedBox(height: 4),
                  Text(
                    'Select the issues that matter most to you',
                    style: AppTextStyles.paragraphP2High
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  if (isLoading && state.subjects.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else if (state.subjects.isEmpty)
                    Text(
                      'No available subjects.',
                      style: AppTextStyles.paragraphP2High
                          .copyWith(color: AppColors.textSecondary),
                    )
                  else
                    Wrap(
                      spacing: 5,
                      runSpacing: 2,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.edit, color: Colors.white, size: 18),
                          label: const Text('Edit'),
                          labelStyle: AppTextStyles.paragraphP2.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.transparent),
                          ),
                          onPressed: () async {
                            final result = await Navigator.of(context).push<List<int>>(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<UserBloc>(),
                                child: InterestScreen(
                                  initialSelected: _interestIds,
                                ),
                                ),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _interestIds
                                  ..clear()
                                  ..addAll(result);
                              });
                            }
                          },
                        ),
                        ..._interestIds.map((id) {
                          final name = state.subjects.firstWhere((s) => s.id == id).name;
                          return Chip(
                            label: Text(
                              name,
                              style: AppTextStyles.paragraphP2.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.transparent),
                            ),
                          );
                        }),
                      ],
                    ),

                  const SizedBox(height: 40.0),
                  SizedBox(
                    width: double.infinity,
                    child: AppButtonWidget(
                      label: isLoading
                          ? 'Saving...'
                          : isNewProfile
                              ? "Let's get started"
                              : 'Update',
                      onPressed: !isLoading &&
                              _isValid(
                                hasSubjects: hasSubjects,
                                isNewProfile: isNewProfile,
                              )
                          ? () => _submit(context)
                          : null,
                      size: AppButtonWidgetSize.large,
                      intent: AppButtonWidgetIntent.primary,
                      tone: AppButtonWidgetTone.solid,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ===== Helper Widgets =====
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) =>
      Text(title, style: AppTextStyles.labelL1);
}

class _DividerSection extends StatelessWidget {
  const _DividerSection();

  @override
  Widget build(BuildContext context) => Divider(
    height: 32.0,
    thickness: 1.0,
    color: AppColors.surfaceContainerLow,
  );
}
