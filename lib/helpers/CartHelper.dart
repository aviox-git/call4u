import 'dart:math';
import 'dart:typed_data';

import 'package:cal4u/Models/GetCalenderModel.dart';
import 'package:cal4u/Models/GetProductModel.dart';
import 'package:cal4u/Models/SavedEvent.dart';
import 'package:cal4u/Models/getNewEventData.dart';
import 'package:flutter/material.dart';

final carthelper = Carthelper();
final cartItems = List<CartItem>();

class Carthelper {
  static final Carthelper _singleton = new Carthelper._internal();

  factory Carthelper() {
    return _singleton;
  }

  Carthelper._internal();
  bool isHebrew;
  bool isSelectedCity;
  Category selectedCity;
  List<AnnualDate> annualDates;
  Product calenderType;
  Calender calenderTemplate;
  List<Uint8List> choosedImages = [];
  List<SavedEvent> events = [];
  bool isFreeTemplate = false;

  bool isCartEmpty() {
    return calenderType == null ||
        calenderTemplate == null ||
        choosedImages.isEmpty;
  }

  saveCart() {
    if (isCartEmpty()) return;
    final item = CartItem(
        calenderType: calenderType,
        calenderTemplate: calenderTemplate,
        choosedImages: choosedImages,
        events: events,
        isHebrew: isHebrew,
        isSelectedCity: isSelectedCity,
        selectedCity: selectedCity,
        annualDates: annualDates,
        isFreeTemplate: isFreeTemplate);
    isFreeTemplate = false;
    calenderType = null;
    calenderTemplate = null;
    choosedImages = [];
    events = [];
    cartItems.add(item);
  }
}

class CartItem {
  bool isHebrew;
  bool isSelectedCity;
  Category selectedCity;
  List<AnnualDate> annualDates;
  Product calenderType;
  Calender calenderTemplate;
  List<Uint8List> choosedImages = [];
  List<SavedEvent> events = [];
  int quantity = 1;
  bool isFreeTemplate = false;
  CartItem(
      {this.isHebrew,
      this.annualDates,
      this.selectedCity,
      this.isSelectedCity,
      this.isFreeTemplate,
      @required this.calenderType,
      @required this.calenderTemplate,
      @required this.choosedImages,
      @required this.events});

  saveToEditingCart() {
    carthelper.calenderTemplate = calenderTemplate;
    carthelper.calenderType = calenderType;
    carthelper.choosedImages = choosedImages;
    carthelper.events = events;
  }

  addItem() {
    quantity++;
  }

  removeItem() {
    quantity = max(1, quantity - 1);
  }
}
