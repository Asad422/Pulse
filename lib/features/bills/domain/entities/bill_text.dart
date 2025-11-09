class BillText {
  final int id;
  final String versionCode;
  final String versionName;
  final DateTime versionDate;
  final String format;
  final String contentText;
  final String url;
  final int billId;

  BillText({
    required this.id,
    required this.versionCode,
    required this.versionName,
    required this.versionDate,
    required this.format,
    required this.contentText,
    required this.url,
    required this.billId,
  });
}
