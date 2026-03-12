import 'package:equatable/equatable.dart';

class Cosponsor extends Equatable {
  final int id;
  final int billId;
  final String politicianId;
  final String? sponsorshipDate;
  final bool? isOriginalSponsor;
  final bool? isOriginalCosponsor;
  final String? sponsorshipWithdrawnDate;
  final String? titlePrefix;
  final String? politicianName;
  final String? politicianParty;
  final String? politicianState;
  final String? politicianChamber;
  final String? politicianPhotoUrl;

  const Cosponsor({
    required this.id,
    required this.billId,
    required this.politicianId,
    this.sponsorshipDate,
    this.isOriginalSponsor,
    this.isOriginalCosponsor,
    this.sponsorshipWithdrawnDate,
    this.titlePrefix,
    this.politicianName,
    this.politicianParty,
    this.politicianState,
    this.politicianChamber,
    this.politicianPhotoUrl,
  });

  @override
  List<Object?> get props => [id, billId, politicianId];
}
