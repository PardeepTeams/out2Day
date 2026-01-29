enum BusinessStatus { pending, approved, rejected }

class BusinessResponseModel {
  int? status;
  String? message;
  List<BusinessModel>? allBusinesses;

  BusinessResponseModel({this.status, this.message, this.allBusinesses});

  BusinessResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['all_businesses'] != null) {
      allBusinesses = <BusinessModel>[];
      json['all_businesses'].forEach((v) {
        allBusinesses!.add(BusinessModel.fromJson(v));
      });
    }
  }
}

class BusinessModel {
  int? id;
  int? userId;
  String? businessName;
  String? category;
  String? description;
  String? webLink;
  String? address;
  List<String>? businessImages;
  String? city;
  String? country;
  String? latitude;
  String? longitude;
  int? status;
  String? createdAt;
  String? updatedAt;
  UserDetail? userDetail;
  String? startTime;
  String? endTime;

  BusinessModel({
    this.id,
    this.userId,
    this.businessName,
    this.category,
    this.description,
    this.webLink,
    this.address,
    this.businessImages,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userDetail,
    this.startTime,
    this.endTime,
  });

  BusinessModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    businessName = json['business_name'];
    category = json['category'];
    description = json['description'];
    webLink = json['web_link'];
    address = json['address'];
    businessImages = json['business_images']?.cast<String>();
    city = json['city'];
    country = json['country'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userDetail = json['user_detail'] != null
        ? UserDetail.fromJson(json['user_detail'])
        : null;

    startTime = json['start_time'];
    endTime = json['end_time'];
  }
}

class UserDetail {
  int? id;
  String? firstName;
  String? lastName;
  String? name;
  String? email;
  String? countryCode;
  String? phone;
  int? role;
  String? gender;
  String? profile;
  String? address;
  String? city;
  String? country;
  String? dob;
  String? profession;
  String? aboutMe;

  UserDetail({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.countryCode,
    this.phone,
    this.role,
    this.gender,
    this.profile,
    this.address,
    this.city,
    this.country,
    this.dob,
    this.profession,
    this.aboutMe,
  });

  UserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['phone'];
    role = json['role'];
    gender = json['gender'];
    profile = json['profile'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    dob = json['dob'];
    profession = json['profession'];
    aboutMe = json['about_me'];
  }
}
