class BillTextModel {
  final int id;
  final String versionCode;
  final String versionName;
  final DateTime versionDate;
  final String format;
  final String contentText;
  final String url;
  final int billId;

  BillTextModel({
    required this.id,
    required this.versionCode,
    required this.versionName,
    required this.versionDate,
    required this.format,
    required this.contentText,
    required this.url,
    required this.billId,
  });

  factory BillTextModel.fromJson(Map<String, dynamic> json) {
    return BillTextModel(
      id: json['id'] as int,
      versionCode: json['version_code'] ?? '',
      versionName: json['version_name'] ?? '',
      versionDate: DateTime.parse(json['version_date']),
      format: json['format'] ?? '',
      contentText: json['content_text'] ?? '',
      url: json['url'] ?? '',
      billId: json['bill_id'] as int,
    );
  }
}
