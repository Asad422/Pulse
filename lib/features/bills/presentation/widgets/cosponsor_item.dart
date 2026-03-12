import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/router/routes.dart';
import 'package:pulse/core/theme/app_colors.dart';
import 'package:pulse/core/theme/text_styles.dart';
import 'package:pulse/features/bills/domain/entities/cosponsor.dart';

class CosponsorItem extends StatelessWidget {
  final Cosponsor cosponsor;
  const CosponsorItem({super.key, required this.cosponsor});

  @override
  Widget build(BuildContext context) {
    final name = cosponsor.politicianName ?? cosponsor.politicianId;
    final subtitle = [
      if (cosponsor.politicianParty != null) cosponsor.politicianParty,
      if (cosponsor.politicianState != null) cosponsor.politicianState,
    ].join(' • ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            AppRoutes.politician,
            pathParameters: {'id': cosponsor.politicianId},
          );
        },
        child: Row(
          children: [
            // Avatar
            CachedNetworkImage(
              imageUrl: cosponsor.politicianPhotoUrl ?? '',
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.surfaceContainerHigh,
                backgroundImage: imageProvider,
              ),
              placeholder: (context, url) => CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.surfaceContainerHigh,
                child: Icon(Icons.person, size: 20, color: AppColors.onSurfaceVariant),
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.surfaceContainerHigh,
                child: Icon(Icons.person, size: 20, color: AppColors.onSurfaceVariant),
              ),
            ),
            const SizedBox(width: 12),
            // Name and info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.paragraphP2Bold.copyWith(
                      color: AppColors.onBackground,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.paragraphP3.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
