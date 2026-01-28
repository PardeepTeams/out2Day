class EthnicityModel {
  int? status;
  String? message;
  List<Ethnicity>? ethnicities;

  EthnicityModel({this.status, this.ethnicities,this.message});

  EthnicityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json["message"]??"No Ethnicity Found";
    if (json['ethnicities'] != null) {
      ethnicities = <Ethnicity>[];
      json['ethnicities'].forEach((v) {
        ethnicities!.add(Ethnicity.fromJson(v));
      });
    }
  }
}

class Ethnicity {
  int? id;
  String? name;

  Ethnicity({this.id, this.name});

  Ethnicity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}