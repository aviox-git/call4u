// To parse this JSON data, do
//
//     final myDates = myDatesFromMap(jsonString);

import 'dart:convert';
import 'package:cal4u/helpers/StoredPrefs.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:http/http.dart' as http;

class MyDatesModel {
  static Future<MyDatesModel> getEvent() async {
    final header = {'Authorization': 'Bearer ' + storedPrefs.accessToken};
    final response = await http.get(baseUrl + 'getEvent', headers: header);
    if (response.statusCode == 200) {
      try {
        final aa = MyDatesModel.fromJson(response.body);
        return aa;
      } catch (err) {
        throw Exception(err);
      }
    } else {
      throw Exception("Status code: ${response.statusCode}");
    }
  }

  MyDatesModel({
    this.success,
    this.event,
    this.status,
  });

  final bool success;
  final List<Event> event;
  final int status;

  factory MyDatesModel.fromJson(String str) => MyDatesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyDatesModel.fromMap(Map<String, dynamic> json) => MyDatesModel(
        success: json["success"] == null ? null : json["success"],
        event: json["event"] == null
            ? null
            : List<Event>.from(json["event"].map((x) => Event.fromMap(x ?? {}))),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "event": event == null
            ? null
            : List<dynamic>.from(event.map((x) => x.toMap())),
        "status": status == null ? null : status,
      };
}

class Event {
  Event({
    this.id,
    this.categoryId,
    this.title,
    this.image,
    this.date,
  });

  final int id;
  final int categoryId;
  final String title;
  final String image;
  final DateTime date;

  factory Event.fromJson(String str) => Event.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Event.fromMap(Map<String, dynamic> json) => Event(
        id: json["id"] == null ? null : json["id"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        title: json["title"] == null ? null : json["title"],
        image: json["image"] == null ? null : json["image"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "category_id": categoryId == null ? null : categoryId,
        "title": title == null ? null : title,
        "image": image == null ? null : image,
        "date": date == null
            ? null
            : "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}
