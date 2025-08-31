import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/features/profile/presentation/widgets/custom_tile.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_app_bar.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/promise_card.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
              child: Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
                  label: Text(
                    'View All Activity',
                    style: AppTextStyles.labelL2.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Divider(height: 1)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Preferences', style: AppTextStyles.titleT2),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  CustomTile(
                    title: 'Language',
                    subtitle: 'English',
                    leading: const Icon(Icons.language, color: AppColors.textSecondary),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                    onTap: () {},
                  ),
                  CustomTile(
                    title: 'Notification Settings',
                    leading: const Icon(Icons.notifications_none, color: AppColors.textSecondary),
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  CustomTile(
                    title: 'Delete Account',
                    leading: const Icon(Icons.delete_outline, color: AppColors.error),
                    destructive: true,
                    onTap: () {},
                  ),
                  CustomTile(
                    title: 'Log Out',
                    leading: const Icon(Icons.logout, color: AppColors.textSecondary),
                    onTap: () => GoRouter.of(context).go(AppPaths.login),
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
              icon: const Icon(Icons.edit, size: 16, color: AppColors.primary),
              label: Text(
                'Edit Profile',
                style: AppTextStyles.buttonMedium.copyWith(color: AppColors.primary),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AppColors.primaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
