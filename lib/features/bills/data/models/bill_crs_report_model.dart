class BillCrsReportModel {
  final int id;
  final String extId;
  final String title;
  final String url;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final String summary;
  final String contentHtml;
  final String contentText;

  BillCrsReportModel({
    required this.id,
    required this.extId,
    required this.title,
    required this.url,
    required this.publishedAt,
    required this.updatedAt,
    required this.summary,
    required this.contentHtml,
    required this.contentText,
  });

  factory BillCrsReportModel.fromJson(Map<String, dynamic> json) {
    return BillCrsReportModel(
      id: json['id'] as int,
      extId: json['ext_id'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      publishedAt: DateTime.parse(json['published_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      summary: json['summary'] ?? '',
      contentHtml: json['content_html'] ?? '',
      contentText: json['content_text'] ?? '',
    );
  }
}
