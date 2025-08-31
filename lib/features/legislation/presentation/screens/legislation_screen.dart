import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/widgets/legislation_vote_card/legislation_vote_card_widget.dart';

class LegislationScreen extends StatelessWidget {
  const LegislationScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar.new(),
        backgroundColor: AppColors.background,
        body: const LegislationVoteCard(featured: true, status: LegislationStatus.passedSenate, subtitle: 'Allocates 1.2T for roads, bridges, public transit, and broadband internet',),
      );
}
