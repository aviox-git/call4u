import 'package:cal4u/Screens/loginPage.dart';
import 'package:cal4u/helpers/StoredPrefs.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:cal4u/helpers/reusable.dart';
import 'package:http/http.dart' as http;

class GetProduct {
  static Future<GetProduct> get(BuildContext context) async {
    final header = {'Authorization': 'Bearer ' + storedPrefs.accessToken};
    final response = await http.get(baseUrl + 'getProducts', headers: header);
    if (response.statusCode == 200) {
      try {
        final aa = GetProduct.fromJson(response.body);
        return aa;
      } catch (err) {
        throw Exception(err);
      }
    } else {
      storedPrefs.accessToken = null;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
      throw Exception("Status code: ${response.statusCode}");
    }
  }

  GetProduct({
    @required this.success,
    @required this.message,
    @required this.data,
  });

  final bool success;
  final String message;
  final List<Product> data;

  factory GetProduct.fromJson(String str) =>
      GetProduct.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetProduct.fromMap(Map<String, dynamic> json) => GetProduct(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Product>.from(json["data"].map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Product {
  Product({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.image,
  });

  final int id;
  final String name;
  final String price;
  final String image;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "price": price == null ? null : price,
        "image": image == null ? null : image,
      };
}
