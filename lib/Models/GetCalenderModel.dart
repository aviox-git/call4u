import 'package:cal4u/helpers/StoredPrefs.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:cal4u/helpers/reusable.dart';
import 'package:http/http.dart' as http;

class GetCalender {
  static Future<GetCalender> get() async {
    final header = {'Authorization': 'Bearer ' + storedPrefs.accessToken};
    final response = await http.get(baseUrl + 'getCalendar', headers: header);
    if (response.statusCode == 200) {
      try {
        final aa = GetCalender.fromJson(response.body);
        return aa;
      } catch (err) {
        throw Exception(err);
      }
    } else {
      throw Exception("Status code: ${response.statusCode}");
    }
  }

  GetCalender({
    @required this.success,
    @required this.message,
    @required this.data,
  });

  final bool success;
  final String message;
  final List<Calender> data;

  factory GetCalender.fromJson(String str) =>
      GetCalender.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetCalender.fromMap(Map<String, dynamic> json) => GetCalender(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Calender>.from(json["data"].map((x) => Calender.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Calender {
  Calender({
    @required this.id,
    @required this.name,
    @required this.image,
  });

  final int id;
  final String name;
  final String image;

  factory Calender.fromJson(String str) => Calender.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Calender.fromMap(Map<String, dynamic> json) => Calender(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image
      };
}
