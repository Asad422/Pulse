import 'package:pulse/core/widgets/politicians_profile_card/policies_dto.dart';

class Politician {
  const Politician({
    required this.name,
    required this.party,
    required this.partyFull,
    required this.country,
    required this.state,
    required this.rating,
    required this.imageUrl,
    required this.inOfficeSinceText,
    required this.policies,
  });

  final String name;
  final String party;
  final String partyFull;
  final String country;
  final String state;
  final double rating;
  final String imageUrl;
  final String inOfficeSinceText;
  final List<PolicyTag> policies;
}