import 'dart:convert';
import 'package:cal4u/helpers/reusable.dart';
import 'package:http/http.dart' as http;

class SuccessMessage {
  static Future<SuccessMessage> forgetPassword(
      String number, String otp, String password) async {
    final body = {"otp": otp, "password": password, "mobile": number};
    final response = await http.post(baseUrl + 'forgot-password', body: body);
    return checkResponse(response);
  }

  static Future<SuccessMessage> contactUs(
      {String phone, String email, String message}) async {
    final body = {"phone": phone, "email": email, "message": message};
    final response = await http.post(baseUrl + 'contactus', body: body);
    return checkResponse(response);
  }

  static SuccessMessage checkResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        final aa = SuccessMessage.fromJson(response.body);
        return aa;
      } catch (err) {
        throw Exception(err);
      }
    } else {
      throw Exception("Status code: ${response.statusCode}");
    }
  }

  static Future<SuccessMessage> sendOtp(String number) async {
    final body = {"mobile": number};
    final response = await http.post(baseUrl + 'sendOtp', body: body);
    return checkResponse(response);
  }

  static Future<SuccessMessage> verifyOtp(String number, String otp) async {
    final body = {"mobile": number, "otp": otp};
    final response = await http.post(baseUrl + 'otpVerified', body: body);
    return checkResponse(response);
  }

  SuccessMessage({this.success, this.message, this.errors});

  final bool success;
  final String message;
  final String errors;

  factory SuccessMessage.fromJson(String str) =>
      SuccessMessage.fromMap(json.decode(str));

  factory SuccessMessage.fromMap(Map<String, dynamic> json) => SuccessMessage(
        success: json["success"] == null ? null : json["success"],
        errors: json["errors"] == null ? null : json["errors"],
        message: json["message"] == null ? null : json["message"],
      );
}
