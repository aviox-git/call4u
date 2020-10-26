// To parse this JSON data, do
//
//     final getShopModel = getShopModelFromMap(jsonString);

import 'dart:convert';
import 'package:cal4u/helpers/reusable.dart';
import 'package:http/http.dart' as http;
import 'package:cal4u/helpers/StoredPrefs.dart';

class GetShopModel {
  static Future<GetShopModel> get() async {
    final header = {'Authorization': 'Bearer ' + storedPrefs.accessToken};
    final response = await http.get(baseUrl + 'getShop', headers: header);
    if (response.statusCode == 200) {
      try {
        final aa = GetShopModel.fromJson(response.body);
        return aa;
      } catch (err) {
        throw Exception(err);
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  GetShopModel({
    this.success,
    this.shop,
  });

  final bool success;
  final List<Shop> shop;

  factory GetShopModel.fromJson(String str) =>
      GetShopModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetShopModel.fromMap(Map<String, dynamic> json) => GetShopModel(
        success: json["success"] == null ? null : json["success"],
        shop: json["shop"] == null
            ? null
            : List<Shop>.from(json["shop"].map((x) => Shop.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "shop": shop == null
            ? null
            : List<dynamic>.from(shop.map((x) => x.toMap())),
      };
}

class Shop {
  Shop({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final dynamic createdAt;
  final dynamic updatedAt;

  factory Shop.fromJson(String str) => Shop.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Shop.fromMap(Map<String, dynamic> json) => Shop(
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
