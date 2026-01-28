class SafetyAdviceResponse {
  int? status;
  String? message;
  List<SafetyCategory>? data;

  SafetyAdviceResponse({this.status, this.message, this.data});

  factory SafetyAdviceResponse.fromJson(Map<String, dynamic> json) {
    return SafetyAdviceResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? List<SafetyCategory>.from(json['data'].map((x) => SafetyCategory.fromJson(x)))
          : [],
    );
  }
}

class SafetyCategory {
  int? id;
  String? name;
  List<SafetyTip>? tips;

  SafetyCategory({this.id, this.name, this.tips});

  factory SafetyCategory.fromJson(Map<String, dynamic> json) {
    return SafetyCategory(
      id: json['id'],
      name: json['name'],
      tips: json['tips'] != null
          ? List<SafetyTip>.from(json['tips'].map((x) => SafetyTip.fromJson(x)))
          : [],
    );
  }
}

class SafetyTip {
  int? id;
  String? title;
  String? description;

  SafetyTip({this.id, this.title, this.description});

  factory SafetyTip.fromJson(Map<String, dynamic> json) {
    return SafetyTip(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}