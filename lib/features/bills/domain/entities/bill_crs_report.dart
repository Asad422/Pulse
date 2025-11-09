class BillCrsReport {
  final int id;
  final String extId;
  final String title;
  final String url;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final String summary;
  final String contentHtml;
  final String contentText;

  BillCrsReport({
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
}
