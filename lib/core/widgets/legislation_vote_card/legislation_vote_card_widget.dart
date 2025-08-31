// legislation_vote_card.dart
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

class LegislationVoteCard extends StatefulWidget {
  const LegislationVoteCard({
    super.key,
    this.title = 'Clean Energy Act. H.R. 3456',
    this.subtitle,
    this.status = LegislationStatus.pendingVote,
    this.featured = true, // можно отключить бейдж "Featured"
    this.introducedText = 'Introduced: May 12, 2023',
    this.initialVotes = 0,
    this.onApprove,
    this.onDisapprove,
  });

  final String title;
  final String? subtitle;
  final LegislationStatus status;
  final bool featured; // если false — бейдж скрывается
  final String introducedText;

  /// Стартовое количество голосов (отображается в центре под полосой)
  final int initialVotes;

  final VoidCallback? onApprove;
  final VoidCallback? onDisapprove;

  @override
  State<LegislationVoteCard> createState() => _LegislationVoteCardState();
}

class _LegislationVoteCardState extends State<LegislationVoteCard> {
  int _support = 0;
  int _oppose = 0;

  void _handleApprove() {
    setState(() => _support++);
    widget.onApprove?.call();
  }

  void _handleDisapprove() {
    setState(() => _oppose++);
    widget.onDisapprove?.call();
  }

  double get _supportFraction {
    final total = _support + _oppose;
    if (total == 0) return 0.5; // по центру, если ни разу не жали
    return _support / total;
  }

  int get _totalVotes => widget.initialVotes + _support + _oppose;

  @override
  Widget build(BuildContext context) {
    final supportPct = (_supportFraction * 100).round();
    final opposePct = 100 - supportPct;

    return Container(
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
                child: Text(widget.title, style: AppTextStyles.get('Title/t3')),
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
                  child:
                      const Text('Featured', style: AppTextStyles.buttonSmall),
                ),
              ],
            ],
          ),

          if (widget.subtitle != null) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.subtitle!,
                style: AppTextStyles.get('Body/p2'),
              ),
            ),
          ],

          const SizedBox(height: 8),

          // ===== Статус + дата =====
          Row(
            children: [
              _statusBadge(widget.status), // <- готовый Container
              const SizedBox(width: 8),
              Text(
                widget.introducedText,
                style: AppTextStyles.get('Label/l2'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===== Индикатор голосов =====
          DualProgressBar(
            fraction: _supportFraction,
            height: 8,
            leftColor: AppColors.green,
            rightColor: AppColors.error,
            background: Colors.transparent, // чтобы разрыв был «пустым»
            gap: 4, // маленькая щель по центру
          ),
          const SizedBox(height: 8),

          // ===== Подписи под индикатором =====
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text('$supportPct%', style: AppTextStyles.get('Label/l2')),
                    const SizedBox(width: 4),
                    const Icon(Icons.thumb_up_alt_outlined,
                        size: 16,
                        color: AppColors.onSurfaceVariant),
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
                    Text('$opposePct%', style: AppTextStyles.get('Label/l2')),
                    const SizedBox(width: 4),
                    const Icon(Icons.thumb_down_alt_outlined,
                        size: 16,
                        color: AppColors.onSurfaceVariant),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ===== Кнопки =====
          Row(
            children: [
              Expanded(
                child: AppButtonWidget.leftIcon(
                  label: 'Support',
                  onPressed: widget.onApprove ?? _handleApprove,
                  intent: AppButtonWidgetIntent.success,
                  tone: AppButtonWidgetTone.subtle,
                  size: AppButtonWidgetSize.medium,
                  leftIcon: Icons.thumb_up_alt_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButtonWidget.leftIcon(
                  label: 'Oppose',
                  onPressed: widget.onDisapprove ?? _handleDisapprove,
                  intent: AppButtonWidgetIntent.danger,
                  tone: AppButtonWidgetTone.subtle,
                  size: AppButtonWidgetSize.medium,
                  leftIcon: Icons.thumb_down_alt_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Маппер статуса в лейбл и стиль кнопки-бейджа
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


