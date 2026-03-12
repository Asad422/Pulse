import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/widgets/app_button_widget.dart';
import 'package:pulse/core/widgets/legislation_vote_card/dual_progress_bar_widget.dart';

enum LegislationStatus {
  inProgress,
  pendingVote,
  committeeReview,
  passedSenate
}

enum LegislationVoteCardType{
  medium,
  large
}

class LegislationVoteCard extends StatefulWidget {
  const LegislationVoteCard({

    super.key,
    this.title = 'Clean Energy Act. H.R. 3456',
    this.subtitle,
    this.description,
    this.status = LegislationStatus.pendingVote,
    this.showStatus = true,
    this.featured = true,
    this.type = LegislationVoteCardType.medium,
    this.introducedText = 'Introduced: May 12, 2023',
    this.initialVotes = 0,
    this.initialSupport = 0,
    this.initialOppose = 0,
    this.isSupportLoading = false,
    this.isOpposeLoading = false,
    this.isSupportActive = false,
    this.isOpposeActive = false,
    this.onApprove,
    this.onDisapprove,
    this.onTap,
    this.showOnlySelectedButton = false,
    this.isVotingDisabled = false,
  });

  final String title;
  final String? subtitle;
  final String? description;
  final LegislationStatus status;
  final bool showStatus;
  final bool featured;
  final String introducedText;
  final int initialVotes;
  final int initialSupport;
  final int initialOppose;
  final bool isSupportLoading;
  final bool isOpposeLoading;
  final bool isSupportActive;
  final bool isOpposeActive;

  final VoidCallback? onApprove;
  final VoidCallback? onDisapprove;

  final LegislationVoteCardType type;

  /// Колбэк при нажатии на карточку
  final VoidCallback? onTap;
  
  /// Показывать только выбранную кнопку (для истории голосов)
  final bool showOnlySelectedButton;
  
  /// Отключить кнопки голосования (во время пагинации)
  final bool isVotingDisabled;

  @override
  State<LegislationVoteCard> createState() => _LegislationVoteCardState();
}

class _LegislationVoteCardState extends State<LegislationVoteCard> {
  late int _support;
  late int _oppose;

  @override
  void initState() {
    super.initState();
    _support = widget.initialSupport;
    _oppose = widget.initialOppose;
  }

  @override
  void didUpdateWidget(covariant LegislationVoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если пришли новые данные голосов с сервера — синхронизируем локальное состояние
    if (oldWidget.initialSupport != widget.initialSupport ||
        oldWidget.initialOppose != widget.initialOppose) {
      _support = widget.initialSupport;
      _oppose = widget.initialOppose;
    }
  }

  void _handleApprove() {
    // Локально счетчик не меняем, только дергаем внешний колбэк
    widget.onApprove?.call();
  }

  void _handleDisapprove() {
    // Локально счетчик не меняем, только дергаем внешний колбэк
    widget.onDisapprove?.call();
  }

  double get _supportFraction {
    final total = _support + _oppose;
    if (total == 0) return 0.5;
    return _support / total;
  }

  int get _totalVotes => _support + _oppose;

  @override
  Widget build(BuildContext context) {
    final supportPct = (_supportFraction * 100).round();
    final opposePct = 100 - supportPct;

    return InkWell(
      onTap: widget.onTap, // ✅ карточка теперь кликабельна
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== Заголовок + Featured =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:
                  Text(widget.title, style: AppTextStyles.get('Title/t3')),
                ),
                if (widget.featured) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: const Text('Featured',
                        style: AppTextStyles.buttonSmall),
                  ),
                ],
              ],
            ),

            if (widget.description != null && widget.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.description!,
                  style: AppTextStyles.get('Body/p2'),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],

            // if (widget.subtitle != null) ...[
            //   const SizedBox(height: 6),
            //   Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       widget.subtitle!,
            //       style: AppTextStyles.get('Body/p2'),
            //     ),
            //   ),
            // ],

            const SizedBox(height: 8),

            // ===== Статус + дата =====
            if (widget.showStatus || widget.introducedText.isNotEmpty) ...[
              Row(
                children: [
                  if (widget.showStatus) ...[
                    _statusBadge(widget.status),
                    const SizedBox(width: 8),
                  ],
                  if (widget.introducedText.isNotEmpty)
                    Text(
                      widget.introducedText,
                      style: AppTextStyles.get('Label/l2'),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // ===== Индикатор голосов =====
            DualProgressBar(
              fraction: _supportFraction,
              height: widget.type == LegislationVoteCardType.large ? 12 : 8,
              leftColor: AppColors.green,
              rightColor: AppColors.error,
              background: Colors.transparent,
              gap: 4,
            ),
            const SizedBox(height: 8),

            // ===== Подписи под индикатором =====
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text('$supportPct%',
                          style: AppTextStyles.get('Label/l2')),
                      const SizedBox(width: 4),
                      const Icon(Icons.thumb_up_alt_outlined,
                          size: 16, color: AppColors.onSurfaceVariant),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '${_formatWithComma(_totalVotes)} votes',
                      style: AppTextStyles.get('Label/l2'),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('$opposePct%',
                          style: AppTextStyles.get('Label/l2')),
                      const SizedBox(width: 4),
                      const Icon(Icons.thumb_down_alt_outlined,
                          size: 16, color: AppColors.onSurfaceVariant),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ===== Кнопки =====
            if (widget.showOnlySelectedButton)
              // Показываем только выбранную кнопку (для истории голосов)
              widget.isSupportActive
                  ? Row(
                    children: [
                      Expanded(
                        child: AppButtonWidget.leftIcon(
                            label: 'Supported',
                            onPressed: null, // Неактивная кнопка
                            isLoading: false,
                            intent: AppButtonWidgetIntent.success,
                            tone: AppButtonWidgetTone.subtle,
                            size: AppButtonWidgetSize.large,
                            leftIcon: Icons.thumb_up_alt_rounded,
                          ),
                      ),
                    ],
                  )
                  : widget.isOpposeActive
                      ? Row(
                        children: [
                          Expanded(
                            child: AppButtonWidget.leftIcon(
                                label: 'Opposed',
                                onPressed: null, // Неактивная кнопка
                                isLoading: false,
                                intent: AppButtonWidgetIntent.danger,
                                tone: AppButtonWidgetTone.subtle,
                                size: AppButtonWidgetSize.large,
                                leftIcon: Icons.thumb_down_alt_rounded,
                              ),
                          ),
                        ],
                      )
                      : const SizedBox.shrink()
            else
              // Показываем обе кнопки (для обычных карточек)
              Row(
                children: [
                  Expanded(
                    child: AppButtonWidget.leftIcon(
                      label: widget.isSupportActive ? 'Supported' : 'Support',
                      onPressed: _handleApprove,
                      isLoading: widget.isSupportLoading,
                      enabled: !widget.isVotingDisabled && !widget.isOpposeLoading,
                      intent: AppButtonWidgetIntent.success,
                      tone: widget.isSupportActive
                          ? AppButtonWidgetTone.solid
                          : AppButtonWidgetTone.subtle,
                      size: AppButtonWidgetSize.medium,
                      leftIcon: Icons.thumb_up_alt_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButtonWidget.leftIcon(
                      label: widget.isOpposeActive ? 'Opposed' : 'Oppose',
                      onPressed: _handleDisapprove,
                      isLoading: widget.isOpposeLoading,
                      enabled: !widget.isVotingDisabled && !widget.isSupportLoading,
                      intent: AppButtonWidgetIntent.danger,
                      tone: widget.isOpposeActive
                          ? AppButtonWidgetTone.solid
                          : AppButtonWidgetTone.subtle,
                      size: AppButtonWidgetSize.medium,
                      leftIcon: Icons.thumb_down_alt_rounded,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(LegislationStatus s) {
    late final String text;
    late final Color bg, fg;

    switch (s) {
      case LegislationStatus.inProgress:
        text = 'In Progress';
        bg = AppColors.primaryContainer;
        fg = AppColors.onPrimaryContainer;
        break;
      case LegislationStatus.committeeReview:
        text = 'Committee Review';
        bg = AppColors.primaryContainer;
        fg = AppColors.onPrimaryContainer;
        break;
      case LegislationStatus.passedSenate:
        text = 'Passed Senate';
        bg = AppColors.greenContainer;
        fg = AppColors.green;
        break;
      case LegislationStatus.pendingVote:
        text = 'Pending Vote';
        bg = AppColors.yellowContainer;
        fg = AppColors.onYellowContainer;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: AppTextStyles.buttonSmall.copyWith(color: fg),
      ),
    );
  }

  String _formatWithComma(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}
