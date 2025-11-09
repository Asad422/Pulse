import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/di.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../domain/entities/user.dart';
import '../bloc/user_bloc.dart';

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
  final _locationCtrl = TextEditingController();

  int? _ageIndex;
  int? _genderIndex;
  final Set<String> _interests = {};

  final _ages = const ['18–25', '26–35', '36–50', '51+'];
  final _genders = const [
    'Man',
    'Woman',
    'Non-binary',
    'Transgender',
    'Prefer not to say'
  ];

  bool _isValid({required bool hasSubjects}) =>
      _nameCtrl.text.trim().isNotEmpty &&
          _ageIndex != null &&
          _genderIndex != null &&
          _locationCtrl.text.trim().isNotEmpty &&
          (hasSubjects ? _interests.isNotEmpty : true);

  Future<void> _openLocationPicker() async {
    final result = await context.push<String>(
      AppPaths.location,
      extra: _locationCtrl.text.isEmpty ? null : _locationCtrl.text,
    );
    if (result != null && result.isNotEmpty && mounted) {
      setState(() => _locationCtrl.text = result);
    }
  }

  void _submit(BuildContext context) {
    final profile = Profile(
      name: _nameCtrl.text.trim(),
      ageCategory: _ages[_ageIndex!],
      interestLevel: _interests.join(', '),
      addressCity: _locationCtrl.text.trim(),
      sex: _genders[_genderIndex!],
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
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      UserBloc(sl(), sl(), sl(), sl(), sl())..add(UserSubjectsRequested()),
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state.status == UserStatus.success && state.user != null) {
            context.go(AppPaths.profile, extra: widget.login);
          } else if (state.status == UserStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'Failed to update profile'),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == UserStatus.loading;
          final subjects = state.subjects.map((s) => s.name).toList();
          final hasSubjects = subjects.isNotEmpty;

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

                    // ===== Full Name =====
                    const _SectionHeader(title: 'Full Name'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      style: AppTextStyles.paragraphP2,
                      decoration: InputDecoration(
                        hintText: 'Enter your full name',
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
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: List.generate(_ages.length, (i) {
                        final selected = _ageIndex == i;
                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(_ages[i]),
                          selected: selected,
                          onSelected: (_) => setState(() => _ageIndex = i),
                          labelStyle: AppTextStyles.paragraphP2.copyWith(
                            color:
                            selected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surfaceContainerLow,
                          shape: const StadiumBorder(),
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
                    TextField(
                      controller: _locationCtrl,
                      readOnly: true,
                      onTap: _openLocationPicker,
                      style: AppTextStyles.paragraphP2,
                      decoration: InputDecoration(
                        hintText: 'Select your city',
                        hintStyle: AppTextStyles.paragraphP2High
                            .copyWith(color: AppColors.textSecondary),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        suffixIcon: IconButton(
                          onPressed: _openLocationPicker,
                          icon: AppIcons.icLocation.svg(
                            width: 20.0,
                            height: 20.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                              color: AppColors.surfaceContainerLow),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _DividerSection(),

                    // ===== Gender =====
                    const _SectionHeader(title: 'Gender'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: List.generate(_genders.length, (i) {
                        final selected = _genderIndex == i;
                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(_genders[i]),
                          selected: selected,
                          onSelected: (_) => setState(() => _genderIndex = i),
                          labelStyle: AppTextStyles.paragraphP2.copyWith(
                            color:
                            selected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surfaceContainerLow,
                          shape: const StadiumBorder(),
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
                    else if (subjects.isEmpty)
                      Text(
                        'No available subjects.',
                        style: AppTextStyles.paragraphP2High
                            .copyWith(color: AppColors.textSecondary),
                      )
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: subjects.map((option) {
                          final selected = _interests.contains(option);
                          return FilterChip(
                            showCheckmark: false,
                            label: Text(option),
                            selected: selected,
                            onSelected: (v) {
                              setState(() {
                                if (v) {
                                  _interests.add(option);
                                } else {
                                  _interests.remove(option);
                                }
                              });
                            },
                            labelStyle: AppTextStyles.paragraphP2.copyWith(
                              color: selected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surfaceContainerLow,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 10.0),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 40.0),
                    SizedBox(
                      width: double.infinity,
                      child: AppButtonWidget(
                        label: isLoading ? 'Saving...' : "Let's get started",
                        onPressed: !isLoading &&
                            _isValid(hasSubjects: hasSubjects)
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
      ),
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
