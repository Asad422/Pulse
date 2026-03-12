import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/di.dart';
import '../../../core/router/routes.dart';
import '../../../core/resources/app_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../features/bills/domain/usecases/get_bills_usecase.dart';
import '../../../features/bills/domain/usecases/vote_for_bill_usecase.dart';
import '../../../features/bills/domain/usecases/cancel_vote_for_bill_usecase.dart';
import '../../../features/bills/presentation/bloc/bills_bloc.dart';
import '../../../features/laws/domain/usecases/get_laws_usecase.dart';
import '../../../features/laws/domain/usecases/vote_for_law_usecase.dart';
import '../../../features/laws/domain/usecases/cancel_vote_for_law_usecase.dart';
import '../../../features/laws/presentation/bloc/laws_bloc.dart';
import '../../../features/politicians/presentation/bloc/politicians_bloc/politicians_bloc.dart';
import '../../../features/profile/presentation/bloc/user_bloc.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static final _tabs = [
    (label: 'Politicians', icon: AppIcons.icPoliticians, path: AppPaths.politicians),
    (label: 'Bills', icon: AppIcons.icLegislations, path: AppPaths.bills),
    (label: 'Laws', icon: AppIcons.icLaws, path: AppPaths.home),
    (label: 'Profile', icon: AppIcons.icProfile, path: AppPaths.profile),
  ];

  int _indexFromLocation(String loc) => _tabs.indexWhere((t) => loc.startsWith(t.path)).clamp(0, _tabs.length - 1);

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(loc);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl())
            ..add(UserVoteHistoryRequested()),
        ),
        BlocProvider(
          create: (_) => BillsBloc(
            sl<GetBillsUseCase>(),
            sl<VoteForBillUseCase>(),
            sl<CancelVoteForBillUseCase>(),
          ),
        ),
        BlocProvider(
          create: (_) => LawsBloc(
            sl<GetLawsUseCase>(),
            sl<VoteForLawUseCase>(),
            sl<CancelVoteForLawUseCase>(),
          ),
        ),
        BlocProvider(
          create: (_) => sl<PoliticiansBloc>(),
        ),
      ],
      child: Scaffold(
        body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.textSecondary.withOpacity(0.2), width: 1),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            height: 60,
            indicatorColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          ),
          child: NavigationBar(
            backgroundColor: Colors.white,
            selectedIndex: currentIndex,
            onDestinationSelected: (i) => context.go(_tabs[i].path),
            destinations: [
              for (var i = 0; i < _tabs.length; i++)
                NavigationDestination(
                  icon: SizedBox(
                    height: 76,
                    child: Center(
                      child: _NavItem(
                        icon: _tabs[i].icon,
                        label: _tabs[i].label,
                        selected: currentIndex == i,
                      ),
                    ),
                  ),
                  label: '',
                ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
  });

  final SvgAsset icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.get("Label/l2") ?? const TextStyle(fontSize: 14);
    final color = selected ? AppColors.primary : AppColors.textSecondary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 13),
        icon.svg(width: 24, height: 24, color: color),
        const SizedBox(height: 4),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          style: base.copyWith(color: color),
          child: Text(label),
        ),
      ],
    );
  }
}
