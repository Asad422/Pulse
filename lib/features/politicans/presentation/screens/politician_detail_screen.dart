import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class PoliticianDetailScreen extends StatelessWidget {
  const PoliticianDetailScreen({super.key, required this.bioguideId});
  final String bioguideId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Politician $bioguideId')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // аватар-заглушка
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 16),

            Text('John Doe', style: AppTextStyles.titleT1),
            const SizedBox(height: 4),
            Text('Party: D • State: CA • Level: federal',
                style: AppTextStyles.paragraphP2High),

            const SizedBox(height: 16),
            Text('About', style: AppTextStyles.titleT3),
            const SizedBox(height: 8),
            Text(
              'This is a placeholder politician profile. Replace with real data '
                  'from GET /politicians/{bioguide_id}.',
              style: AppTextStyles.paragraphP2,
            ),

            const Spacer(),
            FilledButton(
              onPressed: () {},
              child: Text('Support', style: AppTextStyles.get("Button/Medium")),
            ),
          ],
        ),
      ),
    );
  }
}
