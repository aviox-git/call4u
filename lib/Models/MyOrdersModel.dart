// To parse this JSON data, do
//
//     final myOrdersModel = myOrdersModelFromMap(jsonString);

import 'dart:convert';

import 'package:cal4u/helpers/StoredPrefs.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:http/http.dart' as http;

class MyOrdersModel {
  static Future<MyOrdersModel> getOrders() async {
    final header = {'Authorization': 'Bearer ' + storedPrefs.accessToken};
    final response = await http.get(baseUrl + 'myOrder', headers: header);
    if (response.statusCode == 200) {
      try {
        final aa = MyOrdersModel.fromJson(response.body);
        return aa;
      } catch (err) {
        throw Exception(err);
      }
    } else {
      throw Exception("Status code: ${response.statusCode}");
    }
  }
    MyOrdersModel({
        this.success,
        this.order,
        this.status,
    });

    final bool success;
    final List<Order> order;
    final int status;

    factory MyOrdersModel.fromJson(String str) => MyOrdersModel.fromMap(json.decode(str));

    factory MyOrdersModel.fromMap(Map<String, dynamic> json) => MyOrdersModel(
        success: json["success"] == null ? null : json["success"],
        order: json["order"] == null ? null : List<Order>.from(json["order"].map((x) => Order.fromMap(x))),
        status: json["status"] == null ? null : json["status"],
    );

}

class Order {
    Order({
        this.id,
        this.name,
        this.phone,
        this.email,
        this.addressType,
        this.shopId,
        this.city,
        this.street,
        this.apartment,
        this.houseNumber,
        this.senderName,
        this.senderPhone,
        this.senderEmail,
        this.couponId,
        this.userId,
        this.txnId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.calender,
    });

    final int id;
    final String name;
    final String phone;
    final String email;
    final String addressType;
    final int shopId;
    final String city;
    final String street;
    final String apartment;
    final String houseNumber;
    final String senderName;
    final String senderPhone;
    final String senderEmail;
    final int couponId;
    final int userId;
    final dynamic txnId;
    final dynamic status;
    final dynamic createdAt;
    final dynamic updatedAt;
    final List<Calender> calender;

    factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

    factory Order.fromMap(Map<String, dynamic> json) => Order(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        phone: json["phone"] == null ? null : json["phone"],
        email: json["email"] == null ? null : json["email"],
        addressType: json["address_type"] == null ? null : json["address_type"],
        shopId: json["shop_id"] == null ? null : json["shop_id"],
        city: json["city"] == null ? null : json["city"],
        street: json["street"] == null ? null : json["street"],
        apartment: json["apartment"] == null ? null : json["apartment"],
        houseNumber: json["house_number"] == null ? null : json["house_number"],
        senderName: json["sender_name"] == null ? null : json["sender_name"],
        senderPhone: json["sender_phone"] == null ? null : json["sender_phone"],
        senderEmail: json["sender_email"] == null ? null : json["sender_email"],
        couponId: json["coupon_id"] == null ? null : json["coupon_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        txnId: json["txn_id"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        calender: json["calender"] == null ? null : List<Calender>.from(json["calender"].map((x) => Calender.fromMap(x ?? {}))),
    );


}

class Calender {
    Calender({
        this.id,
        this.hebrew,
        this.entShabbat,
        this.cityId,
        this.userId,
        this.productId,
        this.templateId,
        this.orderId,
        this.price,
        this.quantity,
        this.createdAt,
        this.updatedAt,
        this.template,
        this.eventdate,
        this.annualevents,
        this.calenderImages,
    });

    final int id;
    final String hebrew;
    final String entShabbat;
    final int cityId;
    final int userId;
    final int productId;
    final int templateId;
    final int orderId;
    final String price;
    final String quantity;
    final DateTime createdAt;
    final dynamic updatedAt;
    final Template template;
    final List<Eventdate> eventdate;
    final List<Annualevent> annualevents;
    final List<CalenderImage> calenderImages;

    factory Calender.fromJson(String str) => Calender.fromMap(json.decode(str));


    factory Calender.fromMap(Map<String, dynamic> json) => Calender(
        id: json["id"] == null ? null : json["id"],
        hebrew: json["hebrew"] == null ? null : json["hebrew"],
        entShabbat: json["ent_shabbat"] == null ? null : json["ent_shabbat"],
        cityId: json["city_id"] == null ? null : json["city_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        templateId: json["template_id"] == null ? null : json["template_id"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        price: json["price"] == null ? null : json["price"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        template: json["template"] == null ? null : Template.fromMap(json["template"]),
        eventdate: json["eventdate"] == null ? null : List<Eventdate>.from(json["eventdate"].map((x) => Eventdate.fromMap(x))),
        annualevents: json["annualevents"] == null ? null : List<Annualevent>.from(json["annualevents"].map((x) => Annualevent.fromMap(x))),
        calenderImages: json["calender_images"] == null ? null : List<CalenderImage>.from(json["calender_images"].map((x) => CalenderImage.fromMap(x))),
    );

}

class Annualevent {
    Annualevent({
        this.id,
        this.annualDateId,
        this.eventSelectionId,
        this.createdAt,
        this.updatedAt,
    });

    final int id;
    final int annualDateId;
    final int eventSelectionId;
    final dynamic createdAt;
    final dynamic updatedAt;

    factory Annualevent.fromJson(String str) => Annualevent.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Annualevent.fromMap(Map<String, dynamic> json) => Annualevent(
        id: json["id"] == null ? null : json["id"],
        annualDateId: json["annual_date_id"] == null ? null : json["annual_date_id"],
        eventSelectionId: json["event_selection_id"] == null ? null : json["event_selection_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "annual_date_id": annualDateId == null ? null : annualDateId,
        "event_selection_id": eventSelectionId == null ? null : eventSelectionId,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class CalenderImage {
    CalenderImage({
        this.id,
        this.userId,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.productId,
        this.eventSelectionId,
    });

    final int id;
    final int userId;
    final String image;
    final DateTime createdAt;
    final dynamic updatedAt;
    final int productId;
    final int eventSelectionId;

    factory CalenderImage.fromJson(String str) => CalenderImage.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CalenderImage.fromMap(Map<String, dynamic> json) => CalenderImage(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        image: json["image"] == null ? null : json["image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        productId: json["product_id"] == null ? null : json["product_id"],
        eventSelectionId: json["event_selection_id"] == null ? null : json["event_selection_id"],
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "image": image == null ? null : image,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "product_id": productId == null ? null : productId,
        "event_selection_id": eventSelectionId == null ? null : eventSelectionId,
    };
}


class Eventdate {
    Eventdate({
        this.id,
        this.categoryId,
        this.eventSelectionId,
        this.title,
        this.image,
        this.date,
        this.createdAt,
        this.updatedAt,
    });

    final int id;
    final int categoryId;
    final int eventSelectionId;
    final String title;
    final String image;
    final DateTime date;
    final dynamic createdAt;
    final dynamic updatedAt;

    factory Eventdate.fromJson(String str) => Eventdate.fromMap(json.decode(str));

    factory Eventdate.fromMap(Map<String, dynamic> json) => Eventdate(
        id: json["id"] == null ? null : json["id"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        eventSelectionId: json["event_selection_id"] == null ? null : json["event_selection_id"],
        title: json["title"] == null ? null : json["title"],
        image: json["image"] == null ? null : json["image"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );


}


class Template {
    Template({
        this.id,
        this.name,
        this.image,
        this.createdAt,
        this.updatedAt,
    });

    final int id;
    final String name;
    final String image;
    final dynamic createdAt;
    final dynamic updatedAt;

    factory Template.fromJson(String str) => Template.fromMap(json.decode(str));


    factory Template.fromMap(Map<String, dynamic> json) => Template(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );


}

