import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const _kPlaceholderUrl =
    'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png';

class NetworkAvatar extends StatelessWidget {
  const NetworkAvatar({
    super.key,
    required this.url,
    this.size = 88,
    this.placeholderIcon = Icons.person,
  });

  final String? url;
  final double size;
  final IconData placeholderIcon;

  String get _effectiveUrl {
    final u = url;
    if (u != null && u.isNotEmpty && Uri.tryParse(u)?.hasAbsolutePath == true) {
      return u;
    }
    return _kPlaceholderUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: _effectiveUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => _placeholder(),
          errorWidget: (context, url, error) => Container(
            width: size,
            height: size,
            color: Colors.grey.shade200,
            child: Icon(placeholderIcon, size: size * 0.4, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      color: Colors.grey.shade200,
      child: Icon(placeholderIcon, size: size * 0.4, color: Colors.grey.shade400),
    );
  }
}
