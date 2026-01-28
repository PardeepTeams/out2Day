class ProfessionModel {
  int? status;
  List<Profession>? professions;

  ProfessionModel({this.status, this.professions});

  ProfessionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['professions'] != null) {
      professions = <Profession>[];
      json['professions'].forEach((v) {
        professions!.add(Profession.fromJson(v));
      });
    }
  }
}

class Profession {
  int? id;
  String? name;

  Profession({this.id, this.name});

  Profession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}