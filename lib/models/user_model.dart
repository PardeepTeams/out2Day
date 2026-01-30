class UserModel {
  int? status;
  String? message;
  String? token;
  UserData? data;

  UserModel({this.status, this.message, this.token, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['token'] = token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  // 🔹 Name hata ke first_name aur last_name add kitta, aur hobbies add kiti
  String? firstName, lastName, hobbies, email, countryCode, gender,
      latitude, longitude, profile, interests, dob, address, city,
      country, height, ethnicity, profession, aboutMe,phone, drinking,smoking,deviceToken;
  int?  role;
  String? distnace;
//  dynamic? isBusiness;
  List<String>? additionalImages;
  List<String>? additionalImagesThumb;


  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.hobbies,
    this.email,
    this.countryCode,
    this.phone,
    this.gender,
    this.latitude,
    this.longitude,
    this.profile,
    this.interests,
    this.dob,
    this.address,
    this.city,
    this.country,
    this.height,
    this.ethnicity,
    this.profession,
    this.aboutMe,
 //   this.isBusiness,
    this.role,
    this.drinking,
    this.smoking,
    this.distnace,
    this.additionalImages,
    this.additionalImagesThumb,
    this.deviceToken,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    // 🔹 Map JSON keys to variables
    firstName = json['first_name'];
    lastName = json['last_name'];
    hobbies = json['hobbies'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['phone'];
    gender = json['gender'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    profile = json['profile'];
    interests = json['interests'];
    dob = json['dob'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    height = json['height'];
    ethnicity = json['ethnicity'];
    profession = json['profession'];
    aboutMe = json['about_me'];
 //   isBusiness = json['is_business'];
    drinking = json['drinking'];
    smoking = json['smoking'];
    distnace = json["distance"];
    deviceToken = json["device_token"];
    if (json['additional_images'] != null) {
      additionalImages = List<String>.from(json['additional_images']);
    }
    if(json["additional_images_thumb"]!=null){
      additionalImagesThumb = List<String>.from(json['additional_images_thumb']);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'hobbies': hobbies,
      'email': email,
      'country_code': countryCode,
      'phone': phone,
      'gender': gender,
      'latitude': latitude,
      'longitude': longitude,
      'profile': profile,
      'interests': interests,
      'dob': dob,
      'address': address,
      'city': city,
      'country': country,
      'height': height,
      'ethnicity': ethnicity,
      'profession': profession,
      'about_me': aboutMe,
    //  'is_business': isBusiness,
      'role': role,
      'drinking': drinking,
      'smoking': smoking,
      'distance': distnace,
      'additional_images': additionalImages,
      'additional_images_thumb': additionalImagesThumb,
      'device_token': deviceToken,
    };
  }
}