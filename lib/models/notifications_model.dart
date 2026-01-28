class NotificationsModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isRead;

  NotificationsModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}
