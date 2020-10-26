import 'dart:convert';
import 'package:cal4u/Models/GetCalenderModel.dart';
import 'package:http/http.dart' as http;
import 'package:cal4u/helpers/StoredPrefs.dart';
import 'package:cal4u/helpers/reusable.dart';

class GetFreeTemplate {
  static Future<GetFreeTemplate> get() async {
    final header = {'Authorization': 'Bearer ' + storedPrefs.accessToken};
    final response =
        await http.get(baseUrl + 'getFreeShipping', headers: header);
    if (response.statusCode == 200) {
      try {
        final aa = GetFreeTemplate.fromJson(response.body);
        return aa;
      } catch (err) {
        throw Exception(err);
      }
    } else {
      throw Exception("Status code: ${response.statusCode}");
    }
  }

  GetFreeTemplate({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<FreeCal> data;

  factory GetFreeTemplate.fromJson(String str) =>
      GetFreeTemplate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetFreeTemplate.fromMap(Map<String, dynamic> json) => GetFreeTemplate(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<FreeCal>.from(json["data"].map((x) => FreeCal.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class FreeCal {
  FreeCal({
    this.id,
    this.userId,
    this.calenderId,
    this.productId,
    this.calender,
  });

  int id;
  int userId;
  int calenderId;
  int productId;
  Calender calender;

  factory FreeCal.fromJson(String str) => FreeCal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FreeCal.fromMap(Map<String, dynamic> json) => FreeCal(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        calenderId: json["calender_id"] == null ? null : json["calender_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        calender: json["calender"] == null
            ? null
            : Calender.fromMap(json["calender"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "calender_id": calenderId == null ? null : calenderId,
        "product_id": productId == null ? null : productId,
        "calender": calender == null ? null : calender.toMap(),
      };
}
