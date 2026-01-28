class HobbyModel {
  int? status;
  List<Hobby>? hobbies;

  HobbyModel({this.status, this.hobbies});

  HobbyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['hobbies'] != null) {
      hobbies = <Hobby>[];
      json['hobbies'].forEach((v) {
        hobbies!.add(Hobby.fromJson(v));
      });
    }
  }

  // ✅ Manual toJson added
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (hobbies != null) {
      data['hobbies'] = hobbies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hobby {
  int? id;
  String? name;

  Hobby({this.id, this.name});

  Hobby.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  // ✅ Manual toJson added
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}