class Law {
  final int id;
  final int congress;
  final String lawType;
  final String lawNumber;
  final String title;
  final String url;
  final DateTime enactedDate;

  const Law({
    required this.id,
    required this.congress,
    required this.lawType,
    required this.lawNumber,
    required this.title,
    required this.url,
    required this.enactedDate,
  });
}
