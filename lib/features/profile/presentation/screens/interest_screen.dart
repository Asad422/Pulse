import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import '../bloc/user_bloc.dart';

class InterestScreen extends StatefulWidget {
  final Set<int> initialSelected;
  const InterestScreen({super.key, this.initialSelected = const {}});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  final Set<int> _selected = {};
  bool _initialized = false;
  bool _isSaving = false;
  int _pendingAdds = 0;

  void _initSelections(UserState state) {
    _selected.clear();
    if (widget.initialSelected.isNotEmpty) {
      // Используем переданные выбранные id
      _selected.addAll(widget.initialSelected);
    } else {
      // Берём из стейта блока
      final subjectIds = state.subjects.map((s) => s.id).whereType<int>().toSet();
      final interestsIds = state.interests.map((i) => i.subjectId).whereType<int>().toSet();
      final fromInterests = interestsIds.intersection(subjectIds);
      _selected.addAll(fromInterests);

      // Fallback: если интересы не пришли, парсим profile.interestLevel
      if (_selected.isEmpty) {
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
          _selected.addAll(
            names
                .map((n) => nameToId[n])
                .whereType<int>()
                .where((id) => subjectIds.contains(id)),
          );
        }
      }
    }
    _initialized = true;
  }

  bool get _isSelectionValid =>
      _selected.length >= 3 && _selected.length <= 5;

  void _onDonePressed() {
    if (_isSaving || !_isSelectionValid) return;
    final bloc = context.read<UserBloc>();
    final currentInterests =
        bloc.state.interests.map((e) => e.subjectId).whereType<int>().toSet();
    final newIds = _selected.difference(currentInterests);

    // Nothing new to save — just close.
    if (newIds.isEmpty) {
      context.pop();
      return;
    }

    setState(() {
      _isSaving = true;
      _pendingAdds = newIds.length;
    });

    for (final id in newIds) {
      bloc.add(UserAddInterestRequested(subjectId: id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (!_isSaving) return;

        if (state.status == UserStatus.failure) {
          setState(() {
            _isSaving = false;
            _pendingAdds = 0;
          });
          ToastService.showErrorToast(
            context,
            message: state.failure?.message ?? 'Failed to save interests',
            length: ToastLength.medium,
          );
          return;
        }

        if (state.status == UserStatus.success && _pendingAdds > 0) {
          _pendingAdds -= 1;
          if (_pendingAdds == 0) {
            context.read<UserBloc>().add(UserInterestsRequested());
            setState(() {
              _isSaving = false;
            });
            if (mounted) {
              context.pop();
            }
          }
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        buildWhen: (p, c) =>
            p.status != c.status ||
            p.subjects != c.subjects ||
            p.interests != c.interests ||
            p.failure != c.failure,
        builder: (context, state) {
          if (state.status == UserStatus.loading && state.subjects.isEmpty) {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                title: const Text('Key interests', style: AppTextStyles.titleT3),
                backgroundColor: AppColors.background,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
                ),
                scrolledUnderElevation: 0,
              ),
              body: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: 8,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, __) => Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          }

          if (!_initialized && state.subjects.isNotEmpty) {
            _initSelections(state);
          }

          final canSubmit = _isSelectionValid && !_isSaving;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Key interests', style: AppTextStyles.titleT3),
              backgroundColor: AppColors.background,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
              ),
              scrolledUnderElevation: 0,
              actions: [
                TextButton(
                  onPressed: canSubmit ? _onDonePressed : null,
                  child: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                      : Text(
                          'Done',
                          style: AppTextStyles.titleT3.copyWith(
                            color: canSubmit ? AppColors.primary : AppColors.onSurfaceVariant,
                          ),
                        ),
                ),
              ],
            ),
            body: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: state.subjects.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.surfaceContainerLow),
              itemBuilder: (context, index) {
                final subject = state.subjects[index];
                final selected = _selected.contains(subject.id);
                return Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    title: Text(
                      subject.name,
                      style: AppTextStyles.paragraphP2High.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : const SizedBox.shrink(),
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _selected.remove(subject.id);
                        } else {
                          if (_selected.length >= 5) {
                            ToastService.showWarningToast(
                              context,
                              message: 'You can select up to 5 interests',
                              length: ToastLength.medium,
                            );
                            return;
                          }
                          _selected.add(subject.id);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}