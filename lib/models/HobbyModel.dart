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
}

class Hobby {
  int? id;
  String? name;

  Hobby({this.id, this.name});

  Hobby.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}