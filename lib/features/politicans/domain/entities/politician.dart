class Politician {
  final String bigguideId;
  final String firstName;
  final String lastName;
  final String party;
  final String state;
  final int? birthYear;
  final String? photoUrl;
  final String level; // federal / state / local (как в схеме)

  const Politician({
    required this.bigguideId,
    required this.firstName,
    required this.lastName,
    required this.party,
    required this.state,
    required this.level,
    this.birthYear,
    this.photoUrl,
  });
}
