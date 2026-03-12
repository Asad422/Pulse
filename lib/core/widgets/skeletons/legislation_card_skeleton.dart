import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../legislation_vote_card/legislation_vote_card_widget.dart';

class LegislationCardSkeleton extends StatelessWidget {
  const LegislationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: LegislationVoteCard(
        title: 'Loading title placeholder text',
        subtitle: 'Loading subtitle placeholder',
        status: LegislationStatus.inProgress,
        introducedText: 'Introduced: Loading date',
        featured: false,
        initialVotes: 0,
      ),
    );
  }
}
