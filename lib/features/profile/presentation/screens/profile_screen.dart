import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/di.dart';
import '../../../../core/network/secure_token_storage.dart';
import '../../../../core/network/token_storage.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/alerts/app_alert.dart';
import '../../../../core/widgets/promise_card.dart';
import '../../../profile/presentation/widgets/custom_tile.dart';
import '../../../profile/presentation/widgets/profile_app_bar.dart';
import '../bloc/user_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final UserBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = UserBloc(sl(), sl(), sl(), sl(), sl());
    Future.microtask(() => _bloc.add(UserRequested()));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          final user = state.user;
          final city = user?.profile?.addressCity ?? 'Select location';

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: ProfileAppBar(
              country: city, // ✅ передаём локацию из стейта
              notifications: 0,
              onCountryTap: () {
                // переход к экрану выбора локации
                final current = user?.profile?.addressCity ?? '';
                context.push(AppPaths.location, extra: current);
              },
              onBellTap: () {
                // обработчик для уведомлений
                debugPrint('Bell tapped');
              },
            ),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, UserState state) {
    if (state.status == UserStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == UserStatus.failure) {
      return Center(
        child: Text(
          'Error: ${state.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final user = state.user;
    if (user == null) {
      return const Center(child: Text('No user data'));
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _Header(user: user)),

        const SliverToBoxAdapter(child: Divider(height: 1)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Voting History', style: AppTextStyles.titleT2),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.list(
            children: const [
              PromiseCard(
                title: 'Clean Energy Act H.R. 3456',
                dateText: 'June 28, 2023',
                status: PromiseStatus.kept,
                statusText: 'Supported',
              ),
              SizedBox(height: 12),
              PromiseCard(
                title: 'Minimum Wage Increase Act H.R. 603',
                dateText: 'June 25, 2023',
                status: PromiseStatus.broken,
                statusText: 'Opposed',
              ),
              SizedBox(height: 12),
              PromiseCard(
                title: 'Sen. Lisa Chen',
                dateText: 'June 28, 2023',
                status: PromiseStatus.kept,
                statusText: 'Approved',
              ),
            ],
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View All Activity',
                      style: AppTextStyles.buttonLarge
                          .copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    AppIcons.icArrowRight.svg(
                      width: 24,
                      height: 24,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: Divider(height: 1)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 24),
            child: Text('Preferences', style: AppTextStyles.titleT2),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 16, bottom: 24),
            child: Column(
              children: [
                CustomTile(
                  title: 'Language',
                  leading: AppIcons.icLanguage.svg(
                    width: 22,
                    height: 22,
                    color: AppColors.textSecondary,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                CustomTile(
                  title: 'Notification Settings',
                  leading: AppIcons.icNotifications.svg(
                    width: 22,
                    height: 22,
                    color: AppColors.textSecondary,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: Divider(height: 1)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 24, bottom: 40),
            child: Column(
              children: [
                CustomTile(
                  title: 'Delete Account',
                  leading: AppIcons.icTrash.svg(
                    width: 22,
                    height: 22,
                    color: AppColors.error,
                  ),
                  onTap: () async {
                    final ok = await AppAlerts.destructive(
                      context,
                      title: 'Delete account',
                      message:
                      'Are you sure you want to delete your account? This will permanently erase your account.',
                      confirmText: 'Delete',
                      cancelText: 'Cancel',
                    );
                    if (ok && context.mounted) {
                      context.read<UserBloc>().add(UserDeleted());
                      await sl<TokenStorage>().clear();
                      GoRouter.of(context).go(AppPaths.onboarding);
                    }
                  },
                ),
                const SizedBox(height: 20),
                CustomTile(
                  title: 'Log Out',
                  leading: AppIcons.icLogout.svg(
                    width: 22,
                    height: 22,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () async {
                    final ok = await AppAlerts.confirm(
                      context,
                      title: 'Log out',
                      message: 'Are you sure you want to log out?',
                      confirmText: 'Log Out',
                      cancelText: 'Cancel',
                    );
                    if (ok && context.mounted) {
                      await sl<TokenStorage>().clear();
                      GoRouter.of(context).go(AppPaths.login);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final profile = user.profile;
    final name = profile?.name ?? '';
    final city = profile?.addressCity ?? 'Unknown city';
    final joinedDate = user.createdAt.toLocal();
    final formattedDate =
        '${joinedDate.year}-${joinedDate.month.toString().padLeft(2, '0')}-${joinedDate.day.toString().padLeft(2, '0')}';

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(name, style: AppTextStyles.titleT2),
          const SizedBox(height: 4),
          Text(city, style: AppTextStyles.paragraphP2High),
          const SizedBox(height: 2),
          Text('Member since $formattedDate',
              style: AppTextStyles.paragraphP3High),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                final login = user.login;
                context.push(AppPaths.profileSetup, extra: login);
              },
              icon: AppIcons.icPen.svg(width: 16, height: 16),
              label: Text(
                'Edit Profile',
                style: AppTextStyles.buttonLarge
                    .copyWith(color: AppColors.onPrimaryContainer),
              ),
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: AppColors.primaryContainer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
