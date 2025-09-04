import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/features/profile/presentation/widgets/custom_tile.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_app_bar.dart';

import '../../../../core/resources/app_icons.dart'; // 👈 добавили
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/promise_card.dart';
import '../../../../core/widgets/alerts/app_alert.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(),
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header()),
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
                width: double.infinity, // 👈 на всю ширину
                height: 56,             // 👈 фиксированная высота
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent, // оставил как дефолт
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View All Activity',
                        style: AppTextStyles.buttonLarge.copyWith(color: AppColors.primary),
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
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 24),
              child: Column(
                children: [
                  CustomTile(
                    title: 'Language',
                    leading: AppIcons.icLanguage.svg(width: 22, height: 22, color: AppColors.textSecondary),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTile(
                    title: 'Notification Settings',
                    leading: AppIcons.icNotifications.svg(width: 22, height: 22, color: AppColors.textSecondary),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Divider(height: 1)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
              child: Column(
                children: [
                  // Delete account (destructive)
                  CustomTile(
                    title: 'Delete Account',
                    leading: AppIcons.icTrash.svg(width: 22, height: 22),
                    // destructive: true,
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
                        // TODO: удалить аккаунт, очистить сессию
                        GoRouter.of(context).go(AppPaths.login);
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Log out (confirm)
                  CustomTile(
                    title: 'Log Out',
                    leading: AppIcons.icLogout.svg(width: 22, height: 22, color: AppColors.textSecondary),
                    onTap: () async {
                      final ok = await AppAlerts.confirm(
                        context,
                        title: 'Log out',
                        message: 'Are you sure you want to log out?',
                        confirmText: 'Log Out',
                        cancelText: 'Cancel',
                      );
                      if (ok && context.mounted) {
                        // TODO: очистить токены/сессию
                        GoRouter.of(context).go(AppPaths.login);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          const Text('Alex Johnson', style: AppTextStyles.titleT2),
          const SizedBox(height: 4),
          const Text('Washington, DC', style: AppTextStyles.paragraphP2High),
          const SizedBox(height: 2),
          const Text('Member since June 2023', style: AppTextStyles.paragraphP3High),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: AppIcons.icPen.svg(
                width: 16,
                height: 16,
              ),
              label: Text(
                'Edit Profile',
                style: AppTextStyles.buttonLarge.copyWith(color: AppColors.onPrimaryContainer),
              ),
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(56), // 👈 фиксируем высоту
                backgroundColor: AppColors.primaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
