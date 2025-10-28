import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class LocationSelectScreen extends StatefulWidget {
  const LocationSelectScreen({super.key, this.initialSelected});

  final String? initialSelected;

  @override
  State<LocationSelectScreen> createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  static const _cities = <String>[
    'San Francisco, CA',
    'Los Angeles, CA',
    'New York, NY',
  ];

  late String? _selected = widget.initialSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Location'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0, // ✅ отключает тень при скролле
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(
            'Please select the city associated with the legislation and policies you are interested in.',
            style: AppTextStyles.get("Body/p1")?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // список городов с разделителями, галочка у выбранного
          ...List.generate(_cities.length, (i) {
            final city = _cities[i];
            final selected = _selected == city;

            return Column(
              children: [
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(city, style: AppTextStyles.get("Body/p1")),
                  trailing: selected
                      ? const Icon(Icons.check, color: Color(0xFF2F64FF))
                      : null,
                  onTap: () {
                    setState(() => _selected = city);
                    context.pop<String>(city);
                  },
                ),
                const Divider(height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }
}
