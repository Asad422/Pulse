import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app/di/di.dart';
import '../../../../core/auth/auth_notifier.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/widgets/error_empty_state.dart';
import '../../../../core/network/token_storage.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/alerts/app_alert.dart';
import '../../../../core/widgets/promise_card.dart';
import '../../../../core/widgets/skeletons/profile_skeleton.dart';
import '../../../profile/presentation/widgets/custom_tile.dart';
import '../../domain/entities/vote.dart';
import '../bloc/user_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем UserBloc из контекста (из AppShell)
    final userBloc = context.read<UserBloc>();
    final state = userBloc.state;
    
    // Загружаем данные при первом открытии, если они еще не загружены
    if (state.user == null && state.status != UserStatus.loading) {
      userBloc.add(UserRequested());
    }
    if (state.voteHistory.isEmpty && 
        state.status != UserStatus.loading && 
        state.status != UserStatus.initial) {
      userBloc.add(UserVoteHistoryRequested());
    }

    return BlocProvider.value(
      value: userBloc,
      child: BlocBuilder<UserBloc, UserState>(
        buildWhen: (p, c) =>
            p.status != c.status ||
            p.user != c.user ||
            p.failure != c.failure ||
            p.voteHistory != c.voteHistory ||
            p.isLoadingVoteHistory != c.isLoadingVoteHistory,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.background,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SvgPicture.asset(AppIcons.icLogo.path, height: 40, width: 80),
        ),
        leadingWidth: 96,
      ),
            
            body: state.status == UserStatus.loading
                ? const ProfileSkeleton()
                : state.status == UserStatus.failure
                    ? state.failure?.displayType == FailureDisplayType.fullScreen
                        ? ErrorEmptyState(
                            onRetry: () => context.read<UserBloc>().add(UserRequested()),
                          )
                        : state.failure?.displayType == FailureDisplayType.empty
                            ? ErrorEmptyState(
                                title: 'Not found',
                                subtitle: state.failure?.message ?? 'The requested data was not found.',
                              )
                            : Center(
                                child: Text(
                                  state.failure?.message ?? 'Something went wrong',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              )
                    : state.user == null
                        ? const Center(child: Text('No user data'))
                        : CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _Header(user: state.user!)),

        const SliverToBoxAdapter(child: Divider(height: 1)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('My Pulse', style: AppTextStyles.titleT2),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: state.voteHistory.isEmpty && state.isLoadingVoteHistory
              ? SliverList.separated(
                  itemCount: 3,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => const Skeletonizer(
                    enabled: true,
                    child: PromiseCard(
                      title: 'Loading title placeholder text',
                      dateText: 'Loading date',
                      status: PromiseStatus.pending,
                      statusText: 'Loading',
                    ),
                  ),
                )
              : state.voteHistory.isEmpty
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No votes yet',
                        style: AppTextStyles.paragraphP2,
                      ),
                    ),
                  ),
                )
              : Builder(
                  builder: (context) {
                    final sorted = List.from(state.voteHistory)
                      ..sort((a, b) => b.votedAt.compareTo(a.votedAt));
                    final displayCount = sorted.length > 3 ? 3 : sorted.length;
                    
                    return SliverList.separated(
                      itemCount: displayCount,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final vote = sorted[index];
                    final dateText = DateFormat('MMMM d, yyyy').format(vote.votedAt);
                    final status = vote.choice ? PromiseStatus.kept : PromiseStatus.broken;

                    final (title, statusText) = switch (vote) {
                      BillVote(:final bill, :final choice) => (
                        bill.title,
                        choice ? 'Supported' : 'Opposed',
                      ),
                      LawVote(:final law, :final choice) => (
                        law.title,
                        choice ? 'Supported' : 'Opposed',
                      ),
                      PollVote(:final poll, :final choice) => (
                        poll.title,
                        choice ? 'Approved' : 'Rejected',
                      ),
                      _ => (
                        'Vote #${vote.id}',
                        vote.choice ? 'Supported' : 'Opposed',
                      ),
                    };

                    return PromiseCard(
                      title: title,
                      dateText: dateText,
                      status: status,
                      statusText: statusText,
                    );
                      },
                    );
                  },
                ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton(
                onPressed: () {
                  context.pushNamed(AppRoutes.activity);
                  debugPrint('View All Activity tapped');
                },
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
                  onTap: () => context.push(AppPaths.language),
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
                      sl<AuthNotifier>().setLoggedOut();
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
                      sl<AuthNotifier>().setLoggedOut();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
          );
        },
      ),
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
                context.push(AppPaths.profileEdit, extra: login);
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
