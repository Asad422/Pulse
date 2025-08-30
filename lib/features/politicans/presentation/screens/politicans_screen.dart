import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/politicians_profile_card/policies_dto.dart';
import '../../../../core/widgets/politicians_profile_card/politician_dto.dart';
import '../../../../core/widgets/politicians_profile_card/politician_profile_card.dart';
import '../../../../core/widgets/trending_politicians_carousel/trending_politicians_carousel_widget.dart';

class PoliticansScreen extends StatelessWidget {
  const PoliticansScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: Text('title')),
        body: Column(
          children: [
            const TrendingPoliticiansCarousel(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: PoliticianProfileCard(
                politician: Politician(
                  name: 'Sen. John Constantinopolsky',
                  party: 'D',
                  partyFull: 'Democrat',
                  state: 'California',
                  country: 'USA',
                  rating: 100,
                  imageUrl:
                  'https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=400',
                  inOfficeSinceText: 'January 20, 2021',
                  policies: [
                    PolicyTag.green('Climate Action Plan'),
                    PolicyTag.blue('Healthcare Reform'),
                    PolicyTag.red('Tax Reduction'),
                  ],),

              ),
            ),
          ],
        ),
      );
}
