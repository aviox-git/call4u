// To parse this JSON data, do
//
//     final applyCouponModel = applyCouponModelFromMap(jsonString);

import 'dart:convert';
import 'package:cal4u/helpers/StoredPrefs.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:http/http.dart' as http;

class ApplyCouponModel {

    static Future<ApplyCouponModel> apply(String coupon) async {
    final header = {'Authorization': 'Bearer ' + storedPrefs.accessToken};
    final body = {"code": coupon};
    final response = await http.post(baseUrl + 'applyCoupon', headers: header, body: body);
    if (response.statusCode == 200) {
      try {
        final aa = ApplyCouponModel.fromJson(response.body);
        return aa;
      } catch (err) {
        throw Exception(err);
      }
    } else {
      throw Exception("Status code: ${response.statusCode}");
    }
  }

    ApplyCouponModel({
        this.success,
        this.message,
        this.data,
    });

    final bool success;
    final String message;
    final AppliedCoupon data;

    factory ApplyCouponModel.fromJson(String str) => ApplyCouponModel.fromMap(json.decode(str));


    factory ApplyCouponModel.fromMap(Map<String, dynamic> json) => ApplyCouponModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : AppliedCoupon.fromMap(json["data"]),
    );


}

class AppliedCoupon {
    AppliedCoupon({
        this.id,
        this.name,
        this.code,
        this.price,
        this.startDate,
        this.expiryDate,
        this.couponPriceType,
        this.createdAt,
        this.updatedAt,
    });

    final int id;
    final String name;
    final String code;
    final String price;
    final DateTime startDate;
    final DateTime expiryDate;
    final String couponPriceType;
    final DateTime createdAt;
    final DateTime updatedAt;

    factory AppliedCoupon.fromJson(String str) => AppliedCoupon.fromMap(json.decode(str));


    factory AppliedCoupon.fromMap(Map<String, dynamic> json) => AppliedCoupon(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
        price: json["price"] == null ? null : json["price"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        expiryDate: json["expiry_date"] == null ? null : DateTime.parse(json["expiry_date"]),
        couponPriceType: json["coupon_price_type"] == null ? null : json["coupon_price_type"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

}
