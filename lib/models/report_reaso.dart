class ReportReason {
  final int id;
  final String reason;

  ReportReason({required this.id, required this.reason});

  factory ReportReason.fromJson(Map<String, dynamic> json) {
    return ReportReason(
      id: json['id'],
      reason: json['reason'],
    );
  }
}