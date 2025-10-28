import '../../data/models/current_position_model.dart';
import '../../data/models/poll_model.dart';

class Politician {
  final String politicianId;
  final String bioguideId;
  final String firstName;
  final String lastName;
  final String party;
  final String state;
  final String level;
  final String? photoUrl;
  final String? fullName;
  final String? directOrderName;
  final String? chamber;
  final String? stateName;
  final int? sponsoredBillCount;
  final int? cosponsoredBillCount;
  final CurrentPosition? currentPosition;
  final String? district;
  final bool? currentMember;
  final List<Poll>? polls;

  const Politician({
    required this.politicianId,
    required this.bioguideId,
    required this.firstName,
    required this.lastName,
    required this.party,
    required this.state,
    required this.level,
    this.photoUrl,
    this.fullName,
    this.directOrderName,
    this.chamber,
    this.stateName,
    this.sponsoredBillCount,
    this.cosponsoredBillCount,
    this.currentPosition,
    this.district,
    this.currentMember,
    this.polls,
  });
}
