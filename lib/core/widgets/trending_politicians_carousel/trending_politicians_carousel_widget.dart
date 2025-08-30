import 'package:flutter/material.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/widgets/app_button_widget.dart';
import 'package:pulse/core/widgets/trending_politicians_carousel/politician_card_widget.dart';

class TrendingPoliticiansCarousel extends StatelessWidget {
  const TrendingPoliticiansCarousel({super.key});

  // демо-данные
  List<_Politician> get _items => const [
        _Politician(
          name: 'Sen. John Constantinopolsky',
          party: 'D',
          state: 'California',
          rating: 100,
          imageUrl:
              'https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=400',
        ),
        _Politician(
          name: 'Rep. Sarah Johnson',
          party: 'R',
          state: 'Texas',
          rating: 48,
          imageUrl:
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
        ),
        _Politician(
          name: 'Sen. Marcus Lee',
          party: 'D',
          state: 'New York',
          rating: 29,
          imageUrl:
              'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=400',
        ),
        _Politician(
          name: 'Rep. Emily Carter',
          party: 'R',
          state: 'Florida',
          rating: 66,
          imageUrl:
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // заголовок + action
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text('Trending Politicians',
                    style: AppTextStyles.get("Title/t2")),
              ),
              TextButton(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: () {}, // TODO: навигация
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // сама карусель
        SizedBox(
          height: 230, // высота под карточку
          child: ListView.separated(
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final p = items[index];
              return PoliticianCardWidget(
                name: p.name,
                party: p.party,
                state: p.state,
                rating: p.rating.toDouble(),
                imageUrl: p.imageUrl,
                onRate: () {
                  // TODO: обработчик
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Rated ${p.name}')),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Politician {
  const _Politician({
    required this.name,
    required this.party,
    required this.state,
    required this.rating,
    required this.imageUrl,
  });

  final String name;
  final String party;
  final String state;
  final int rating;
  final String imageUrl;
}
