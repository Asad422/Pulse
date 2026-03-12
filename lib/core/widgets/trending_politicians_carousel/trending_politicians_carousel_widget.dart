import 'package:flutter/material.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/core/widgets/politicians_profile_card/politician.dart';
import 'package:pulse/core/widgets/trending_politicians_carousel/politician_carousel_card_widget.dart';

class TrendingPoliticiansCarousel extends StatelessWidget {
  const TrendingPoliticiansCarousel({super.key});

  // демо-данные
  List<Politician> get _items => const [
        Politician(
          name: 'Sen. John Constantinopolsky',
          party: 'D',
          partyFull: 'Democrat',
          inOfficeSinceText: 'In office since: January 20, 2021',
          country: 'USA',
          state: 'California',
          rating: 100,
          imageUrl:
              'https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=400', policies: [],
        ),
        Politician(
          name: 'Rep. Sarah Johnson',
          party: 'R',
          partyFull: 'Democrat',
          inOfficeSinceText: 'In office since: January 20, 2021',
          country: 'USA',
          state: 'Texas',
          rating: 48,
          imageUrl:
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400', policies: [],
        ),
        Politician(
          name: 'Sen. Marcus Lee',
          party: 'D',
          partyFull: 'Democrat',
          inOfficeSinceText: 'In office since: January 20, 2021',
          country: 'USA',
          state: 'New York',
          rating: 29,
          imageUrl:
              'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=400', policies: [],
        ),
        Politician(
          name: 'Rep. Emily Carter',
          party: 'R',
          partyFull: 'Democrat',
          inOfficeSinceText: 'In office since: January 20, 2021',
          country: 'USA',
          state: 'Florida',
          rating: 66,
          imageUrl:
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', policies: [],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // заголовок + кнопка "See All"
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

        // карусель с карточками политиков
        SizedBox(
          height: 230, // высота под карусель с карточками
          child: ListView.separated(
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final p = items[index];
              return PoliticianCarouselCardWidget(
                name: p.name,
                party: p.party,
                state: p.state,
                rating: p.rating.toDouble(),
                imageUrl: p.imageUrl,
                onRate: () {
                  // TODO: обработчик
                  ToastService.showSuccessToast(
                    context,
                    message: 'Rated ${p.name}',
                    length: ToastLength.medium,
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
