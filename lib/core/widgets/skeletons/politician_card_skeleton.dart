import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../politicians_profile_card/politician.dart';
import '../politicians_profile_card/politician_profile_card.dart';

class PoliticianCardSkeleton extends StatelessWidget {
  const PoliticianCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: PoliticianProfileCard(
        politician: Politician(
          name: 'Loading Name Placeholder',
          party: 'Loading Party',
          partyFull: 'Loading Party Full',
          state: 'Loading State',
          country: 'Loading Country',
          rating: 50.0,
          imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
          inOfficeSinceText: 'Loading office text',
          policies: const [],
          totalVotes: 100, // Добавляем значения для отображения блока статистики
          votesFor: 60,
          votesAgainst: 40,
        ),
      ),
    );
  }
}
