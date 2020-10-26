
import 'dart:convert';
import 'package:cal4u/helpers/StoredPrefs.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:http/http.dart' as http;

class GetNewEventData {
    static Future<GetNewEventData> get() async {
    final header = {'Authorization': 'Bearer ' + storedPrefs.accessToken};
    final response = await http.get(baseUrl + 'getData', headers: header);
    try {
      final aa = GetNewEventData.fromJson(response.body);
      return aa;
    } catch (err) {
      throw Exception(err);
    }
  }
    GetNewEventData({
        this.success,
        this.annualDate,
        this.city,
        this.category,
    });

    final bool success;
    final List<AnnualDate> annualDate;
    final List<Category> city;
    final List<Category> category;

    factory GetNewEventData.fromJson(String str) => GetNewEventData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetNewEventData.fromMap(Map<String, dynamic> json) => GetNewEventData(
        success: json["success"] == null ? null : json["success"],
        annualDate: json["annualDate"] == null ? null : List<AnnualDate>.from(json["annualDate"].map((x) => AnnualDate.fromMap(x))),
        city: json["city"] == null ? null : List<Category>.from(json["city"].map((x) => Category.fromMap(x))),
        category: json["category"] == null ? null : List<Category>.from(json["category"].map((x) => Category.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "annualDate": annualDate == null ? null : List<dynamic>.from(annualDate.map((x) => x.toMap())),
        "city": city == null ? null : List<dynamic>.from(city.map((x) => x.toMap())),
        "category": category == null ? null : List<dynamic>.from(category.map((x) => x.toMap())),
    };
}

class AnnualDate {
    AnnualDate({
        this.id,
        this.title,
        this.date,
        this.createdAt,
        this.updatedAt,
    });

    final int id;
    final String title;
    final DateTime date;
    final dynamic createdAt;
    final dynamic updatedAt;
    bool isSelected = false;

    factory AnnualDate.fromJson(String str) => AnnualDate.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AnnualDate.fromMap(Map<String, dynamic> json) => AnnualDate(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "date": date == null ? null : "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class Category {
    Category({
        this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
    });

    final int id;
    final String name;
    final dynamic createdAt;
    final dynamic updatedAt;

    factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
