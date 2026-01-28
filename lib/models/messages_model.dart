class MessagesModel {
  String? message;
  int? timestamp;
  int? sender;
  int? receiver;
  String? requestId;

  MessagesModel({
    this.message,
    this.timestamp,
    this.sender,
    this.receiver,
    this.requestId,
  });

  MessagesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    timestamp = json['timestamp'];
    sender = json['sender'];
    receiver = json['receiver'];
    requestId = json['requestId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['timestamp'] = timestamp;
    data['sender'] = sender;
    data['receiver'] = receiver;
    data['requestId'] = requestId;
    return data;
  }
}
