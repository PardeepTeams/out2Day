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

  // ✅ Manual toJson added for caching
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (professions != null) {
      data['professions'] = professions!.map((v) => v.toJson()).toList();
    }
    return data;
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

  // ✅ Manual toJson added for caching
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}