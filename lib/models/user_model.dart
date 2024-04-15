
class UserModel {
  String? name;
  String? phone;
  String? email;
  String? password;

  UserModel({this.name, this.phone, this.email, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["phone"] is String) {
      phone = json["phone"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    if(json["password"] is String) {
      password = json["password"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["phone"] = phone;
    _data["email"] = email;
    _data["password"] = password;
    return _data;
  }
}