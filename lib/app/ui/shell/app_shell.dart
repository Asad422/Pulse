import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  static final _tabs = [
    (label: 'Legislations', icon: Icons.article, path: AppPaths.home),
    (label: 'Search',       icon: Icons.search,  path: AppPaths.search),
    (label: 'Profile',      icon: Icons.person,  path: AppPaths.profile),
  ];

  int _indexFromLocation(String loc) =>
      _tabs.indexWhere((t) => loc.startsWith(t.path)).clamp(0, _tabs.length - 1);

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(loc);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: [
          for (final t in _tabs) NavigationDestination(icon: Icon(t.icon), label: t.label),
        ],
      ),
    );
  }
}
