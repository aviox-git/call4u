import 'dart:convert';
import 'package:cal4u/helpers/reusable.dart';
import 'package:http/http.dart' as http;

class RegisterUserResponse {

  static Future<RegisterUserResponse> socialLogin(Map<String, String> body) async {
        final response = await http.post(baseUrl + 'social-login', body: body);
    if (response.statusCode == 200) {
      try {
        final aa = RegisterUserResponse.fromJson(response.body);
        return aa;
      } catch (err) {
        throw Exception(err);
      }
    } else {
      throw Exception("Status code: ${response.statusCode}");
    }
  }


  static Future<RegisterUserResponse> loginUser(
      String number, String password) async {
    final body = {"mobile": number, "password": password};
    final response = await http.post(baseUrl + 'login', body: body);
    if (response.statusCode == 200) {
      try {
        final aa = RegisterUserResponse.fromJson(response.body);
        return aa;
      } catch (err) {
        throw Exception(err);
      }
    } else {
      throw Exception("Status code: ${response.statusCode}");
    }
  }

  static Future<RegisterUserResponse> registerUser(
      {String number, String password, String name, String email}) async {
    final body = {
      "name": name,
      "email": email,
      "mobile": number,
      "password": password
    };
    final response = await http.post(baseUrl + 'signup', body: body);
    if (response.statusCode == 200) {
      try {
        final aa = RegisterUserResponse.fromJson(response.body);
        return aa;
      } catch (err) {
        throw Exception(err);
      }
    } else {
      throw Exception("Status code: ${response.statusCode}");
    }
  }

  RegisterUserResponse(
      {this.data,
      this.message,
      this.user,
      this.accessToken,
      this.success,
      this.errors});

  final String message;
  final User user;
  final User data;
  final String accessToken;
  final bool success;
  final String errors;

  factory RegisterUserResponse.fromJson(String str) =>
      RegisterUserResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterUserResponse.fromMap(Map<String, dynamic> json) =>
      RegisterUserResponse(
        message: json["message"] == null ? null : json["message"],
        errors: json["errors"] == null ? null : json["errors"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
        data: json["data"] == null ? null : User.fromMap(json["data"]),
        accessToken: json["access_token"] == null ? null : json["access_token"],
        success: json["success"] == null ? null : json["success"],
      );

  Map<String, dynamic> toMap() => {
        "message": message == null ? null : message,
        "user": user == null ? null : user.toMap(),
        "access_token": accessToken == null ? null : accessToken,
        "success": success == null ? null : success,
      };
}

class User {
  User({
    this.id,
    // this.facebookId,
    // this.googleplusId,
    this.name,
    this.email,
    this.countryCode,
    this.mobile,
    this.status,
    // this.createdAt,
    // this.updatedAt,
  });

  final int id;
  // final String facebookId;
  // final String googleplusId;
  final String name;
  final String email;
  final String countryCode;
  final String mobile;
  final String status;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        // facebookId: json["facebook_id"],
        // googleplusId: json["googleplus_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        status: json["status"] == null ? null : json["status"],
        // createdAt: json["created_at"] == null
        //     ? null
        //     : DateTime.parse(json["created_at"]),
        // updatedAt: json["updated_at"] == null
        //     ? null
        //     : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        // "facebook_id": facebookId,
        // "googleplus_id": googleplusId,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "country_code": countryCode,
        "mobile": mobile == null ? null : mobile,
        "status": status == null ? null : status,
        // "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        // "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
