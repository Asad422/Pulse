import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/widgets/legislation_vote_card/legislation_vote_card_widget.dart';

class LawsScreen extends StatelessWidget {
  const LawsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text('Legislations'),
        ),
        backgroundColor: AppColors.background,
        body: ListView(children: const [
          Column(
            children: [
              LegislationVoteCard(
                featured: true,
                status: LegislationStatus.passedSenate,
                subtitle:
                    'Allocates 1.2T for roads, bridges, public transit, and broadband internet',
              ),
              LegislationVoteCard(
                featured: true,
                status: LegislationStatus.passedSenate,
                subtitle:
                    'Allocates 1.2T for roads, bridges, public transit, and broadband internet',
              ),
              LegislationVoteCard(
                featured: true,
                status: LegislationStatus.passedSenate,
                subtitle:
                    'Allocates 1.2T for roads, bridges, public transit, and broadband internet',
              ),
              LegislationVoteCard(
                featured: true,
                status: LegislationStatus.passedSenate,
                subtitle:
                    'Allocates 1.2T for roads, bridges, public transit, and broadband internet',
              ),
            ],
          ),
        ]),
      );
}
