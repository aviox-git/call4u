import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cal4u/Models/MyOrdersModel.dart';
import 'package:cal4u/Models/applyCouponModel.dart';
import 'package:cal4u/Models/getshop.dart';
import 'package:cal4u/Models/successMessage.dart';
import 'package:cal4u/Screens/AddEventScreen.dart';
import 'package:cal4u/Screens/CartWidgets.dart';
import 'package:cal4u/Screens/EditChosedPics.dart';
import 'package:cal4u/Screens/HomePage.dart';
import 'package:cal4u/Screens/OrderFailure.dart';
import 'package:cal4u/Screens/OrderSuccess.dart';
import 'package:cal4u/helpers/CartHelper.dart';
import 'package:cal4u/helpers/StoredPrefs.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart' as intl;
import 'package:cal4u/helpers/MultipartRequest.dart' as progressMulti;

class CartScreen extends StatefulWidget {
  final Order repeatOrder;

  const CartScreen({Key key, this.repeatOrder}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  var _showEntryFields = false;
  var _isCouponErrorShow = false;
  final couponController = TextEditingController();
  final _pickupTextField = TextEditingController();
  final senderNameTextController = TextEditingController();
  final senderPhoneTextController = TextEditingController();
  final senderEmailTextController = TextEditingController();
  final receiverNameTextController = TextEditingController();
  final receiverPhoneTextController = TextEditingController();
  final receiverCityTextController = TextEditingController();
  final receiverStreetTextController = TextEditingController();
  final receiverHousenumberTextController = TextEditingController();
  final receiverApartmentTextController = TextEditingController();
  final receiverEmailTextController = TextEditingController();
  var _isPickupEntry = true;
  List<Shop> shops = [];
  int _selectedShopIndex;
  Order repeatOrder;
  int changedQuantity;
  AppliedCoupon _appliedCoupon;
  double _loadinProgress;
  @override
  void initState() {
    super.initState();
    GetShopModel.get().then((value) => shops = value.shop);
    repeatOrder = widget.repeatOrder;
    changedQuantity = int.parse(repeatOrder?.calender?.first?.quantity ?? "0");
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: commonAppbar(context),
      body: _isLoading
          ? _loadinProgress != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('אנא המתן לשלוח בקשה'),
                      SizedBox(height: 10),
                      CircularProgressIndicator(
                          strokeWidth: 5,
                          backgroundColor: Colors.blue[200],
                          value: _loadinProgress)
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: cartContentView(context),
                ),
                SafeArea(child: AppTabBar(selectedIndex: 1))
              ],
            ),
    );
  }

  SingleChildScrollView cartContentView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TitleRedText(text: 'עגלה'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('מוצר '), Text('סכום')],
          ),
          Container(height: 2, color: Colors.grey),
          SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 20),
            itemCount: widget.repeatOrder == null ? cartItems.length : 1,
            separatorBuilder: (c, a) => Divider(),
            itemBuilder: (c, i) => widget.repeatOrder == null
                ? cartItem(c, i)
                : repeatOrderCartItem(),
          ),
          SizedBox(height: 20),
          _showEntryFields
              ? CouponTextArea(
                  couponController: couponController,
                  onApply: () async {
                    if (couponController.text.isEmpty) {
                      Fluttertoast.showToast(msg: 'אנא הזן קוד קופון');
                      return;
                    }
                    final response =
                        await ApplyCouponModel.apply(couponController.text);
                    if (response.success) {
                      Fluttertoast.showToast(msg: 'הוחל על השובר');
                      _appliedCoupon = response.data;
                    } else {
                      Fluttertoast.showToast(msg: 'הקופון לא הוחל');
                    }
                  },
                )
              : AddCouponButton(),
          if (_isCouponErrorShow)
            Text(
              'קוד קופון לא נמצא במערכת',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w800,
                  fontSize: 50.sp),
            ).rightAligned(),
          //////////
          if (_showEntryFields)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(thickness: 2, height: 30),
                InkWell(
                  onTap: () => setState(() => _isPickupEntry = true),
                  child: RadioButtonTitle(
                          selected: _isPickupEntry, title: 'איסוף עצמי')
                      .rightAligned()
                      .padding(),
                ),
                if (_isPickupEntry)
                  DropDownTextField(
                      hintText: 'איסוף עצמי',
                      controller: _pickupTextField,
                      onTap: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (c) => ListDropDown(
                                  nameList: shops.map((e) => e.name).toList(),
                                  ontap: (i) {
                                    _selectedShopIndex = i;
                                    _pickupTextField.text =
                                        shops.map((e) => e.name).toList()[i];
                                    Navigator.of(context).pop();
                                  },
                                ));
                      }),
                InkWell(
                  onTap: () => setState(() => _isPickupEntry = false),
                  child: RadioButtonTitle(
                          selected: !_isPickupEntry, title: 'פיצול משלוח')
                      .rightAligned()
                      .padding(),
                ),
                if (!_isPickupEntry) buildAddressFields(),
                buildTotalSection(context),
              ],
            ),
          /////
          if (!_showEntryFields && cartItems.length == 1)
            SizedBox(height: 180.h),
          AppRaisedButton(
              title: 'לתשלום',
              onTap: () {
                if (!_showEntryFields) {
                  _showEntryFields = true;
                  setState(() {});
                  return;
                }
                _checkCondition();
              }).padding(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildAddressFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'פרטי מקבל המשלוח',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
        ),
        textFieldTitle('שם ושם משפחה')
            .padding(EdgeInsets.symmetric(vertical: 8)),
        AppTextField(
            hintText: 'יובל ויצמן',
            controller: receiverNameTextController,
            keyboardType: TextInputType.name),
        textFieldTitle('טלפון').padding(EdgeInsets.symmetric(vertical: 8)),
        AppTextField(
            hintText: '054-1234567',
            controller: receiverPhoneTextController,
            keyboardType: TextInputType.phone),
        textFieldTitle('מייל').padding(EdgeInsets.symmetric(vertical: 8)),
        AppTextField(
            hintText: 'xx@yy.com',
            controller: receiverEmailTextController,
            keyboardType: TextInputType.emailAddress),
        textFieldTitle('עיר').padding(EdgeInsets.symmetric(vertical: 8)),
        AppTextField(
          hintText: 'תל אביב',
          controller: receiverCityTextController,
        ),
        textFieldTitle('רחוב').padding(EdgeInsets.symmetric(vertical: 8)),
        AppTextField(
          hintText: 'תל אביב',
          controller: receiverStreetTextController,
        ),
        Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  textFieldTitle('מספר')
                      .padding(EdgeInsets.symmetric(vertical: 8)),
                  AppTextField(
                    hintText: '976',
                    controller: receiverHousenumberTextController,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  textFieldTitle('דירה')
                      .padding(EdgeInsets.symmetric(vertical: 8)),
                  AppTextField(
                    hintText: '976',
                    controller: receiverHousenumberTextController,
                  ),
                ],
              ),
            )
          ],
        ).padding(),
        senderIsReceiver(),
        Text(
          'פרטי השולח',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
        ),
        textFieldTitle('שם ושם משפחה')
            .padding(EdgeInsets.symmetric(vertical: 8)),
        AppTextField(
            hintText: 'יובל ויצמן',
            controller: senderNameTextController,
            keyboardType: TextInputType.name),
        textFieldTitle('טלפון').padding(EdgeInsets.symmetric(vertical: 8)),
        AppTextField(
            hintText: '054-1234567',
            controller: senderPhoneTextController,
            keyboardType: TextInputType.phone),
        textFieldTitle('מייל').padding(EdgeInsets.symmetric(vertical: 8)),
        AppTextField(
            hintText: 'xx@yy.com',
            controller: senderEmailTextController,
            keyboardType: TextInputType.emailAddress),
      ],
    ).padding();
  }

  Widget senderIsReceiver() {
    return InkWell(
      onTap: () {
        senderEmailTextController.text = receiverEmailTextController.text;
        senderNameTextController.text = receiverNameTextController.text;
        senderPhoneTextController.text = receiverPhoneTextController.text;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(color: Theme.of(context).buttonColor, blurRadius: 1)
          ],
        ),
        child: Text(
          'שיוך פריטים ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 60.sp,
              color: Theme.of(context).buttonColor),
        ),
      ),
    );
  }

  Text textFieldTitle(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w200, fontSize: 50.sp),
    );
  }

  Container buildTotalSection(BuildContext context) {
    final totalPrice = cartItems.fold(
        0,
        (previousValue, element) =>
            (element.quantity *
                (double.tryParse(element.calenderType.price) ?? 0)) +
            previousValue);
    final discount = double.parse(_appliedCoupon?.price ?? "0");
    final grandTotal = totalPrice - discount + 25;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)]),
      child: Column(
        children: [
          Text(
            'סיכום הזמנה',
            style: TextStyle(
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).buttonColor),
          ),
          priceName(totalPrice.toDouble(), 'מחיר פריטים'),
          priceName(25, 'מחיר משלוח'),
          priceName(discount, 'הנחת קופון'),
          Divider(thickness: 2, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('סה"כ',
                  style: TextStyle(
                    fontSize: 50.sp,
                    fontWeight: FontWeight.bold,
                  )),
              Text(
                '${grandTotal.toStringAsFixed(2)} ₪',
                style: TextStyle(
                  fontSize: 50.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Row priceName(double price, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: TextStyle(fontSize: 40.sp)),
        Text(
          '${price.toStringAsFixed(2)} ₪',
          style: TextStyle(
            fontSize: 40.sp,
          ),
        ),
      ],
    );
  }

  Widget repeatOrderCartItem() {
    final cal = repeatOrder.calender.first;
    final oldPrice = double.parse(cal.price);
    final oldQ = int.parse(cal.quantity);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 100,
            child: CachedNetworkImage(
              imageUrl: cal.template.image,
              fit: BoxFit.fitWidth,
            )),
        SizedBox(width: 20.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cal.template.name,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 50.sp)),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 1, color: Colors.grey[300])
                    ],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: Icon(Icons.keyboard_arrow_up,
                            color: Theme.of(context).buttonColor),
                        onTap: () {
                          changedQuantity++;
                          setState(() {});
                        },
                      ),
                      InkWell(
                        child: Icon(Icons.keyboard_arrow_down,
                            color: Theme.of(context).buttonColor),
                        onTap: () {
                          changedQuantity = max(1, changedQuantity - 1);
                          setState(() {});
                        },
                      ),
                      Text(
                        changedQuantity.toString(),
                        style: TextStyle(
                            fontSize: 45.sp, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                SizedBox(width: 20.w),
                SizedBox(width: 20.w),
                Text(
                    '${(oldPrice / oldQ * changedQuantity).toStringAsFixed(2)} ₪'),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget cartItem(BuildContext context, int index) {
    final item = cartItems[index];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 100,
            child: CachedNetworkImage(
              imageUrl: item.calenderTemplate.image,
              fit: BoxFit.fitWidth,
            )),
        SizedBox(width: 20.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.calenderTemplate.name,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 50.sp)),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 1, color: Colors.grey[300])
                    ],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: Icon(Icons.keyboard_arrow_up,
                            color: Theme.of(context).buttonColor),
                        onTap: () {
                          item.addItem();
                          setState(() {});
                        },
                      ),
                      InkWell(
                        child: Icon(Icons.keyboard_arrow_down,
                            color: Theme.of(context).buttonColor),
                        onTap: () {
                          item.removeItem();
                          setState(() {});
                        },
                      ),
                      Text(
                        item.quantity.toString(),
                        style: TextStyle(
                            fontSize: 45.sp, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                InkWell(
                  onTap: () {
                    item.saveToEditingCart();
                    cartItems.removeAt(index);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) => EditChosedPic()),
                        (route) => false);
                  },
                  child: Image.asset(
                    'images/editCart.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                SizedBox(width: 20.w),
                InkWell(
                  onTap: () {
                    showCupertinoDialog(
                        context: context,
                        builder: (c) => CartPopUp(
                              message: """
אתה בטוח שרוצה
למחוק את האלבום?
          """,
                              onAccept: () {
                                cartItems.removeAt(index);
                                if (cartItems.isEmpty) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (c) => HomePage()),
                                      (route) => false);
                                } else {
                                  setState(() {});
                                }
                              },
                            ));
                  },
                  child: Image.asset(
                    'images/picDelete.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                SizedBox(width: 20.w),
                Text(
                    '${(double.parse(item.calenderType.price) * item.quantity).toStringAsFixed(2)} ₪'),
              ],
            )
          ],
        ),
      ],
    );
  }

  void _checkCondition() {
    if (_isPickupEntry && _pickupTextField.text.isEmpty) {
      Fluttertoast.showToast(msg: 'אנא בחר איסוף');
      return;
    } else if (!_isPickupEntry) {
      if (senderNameTextController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'אנא הוסף את שם השולח');
        return;
      }
      if (senderPhoneTextController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'אנא הוסף טלפון שולח');
        return;
      }
      if (senderEmailTextController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'אנא הוסף דוא"ל שולח');
        return;
      }
      if (receiverNameTextController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'אנא הוסף שם מקלט');
        return;
      }
      if (receiverPhoneTextController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'אנא הוסף טלפון מקלט');
        return;
      }
      if (receiverCityTextController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'אנא הוסף עיר מקלט');
        return;
      }
      if (receiverStreetTextController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'אנא הוסף רחוב מקלט');
        return;
      }

      if (receiverEmailTextController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'אנא הוסף דוא"ל מקלט');
        return;
      }
    }
    if (widget.repeatOrder == null) {
      _placeOrder();
    } else {
      _repeatOrder();
    }
  }

  void _repeatOrder() async {
    final cal = repeatOrder.calender.first;
    final oldPrice = double.parse(cal.price);
    final oldQ = int.parse(cal.quantity);

    Map<String, String> body = {
      "receiverName": receiverNameTextController.text,
      "receiverPhone": receiverPhoneTextController.text,
      "receiverEmail": receiverEmailTextController.text,
      "receiverCity": receiverCityTextController.text,
      "receiverStreet": receiverStreetTextController.text,
      "receiverHouse": receiverHousenumberTextController.text,
      "receiverApartment": receiverApartmentTextController.text,
      "senderName": senderNameTextController.text,
      "senderEmail": senderEmailTextController.text,
      "senderPhone": senderPhoneTextController.text,
      "appliedCoupon": _appliedCoupon?.code.toString() ?? "",
      "isPicup": _isPickupEntry.toString(),
      "pickupId": _isPickupEntry ? shops[_selectedShopIndex].id.toString() : "",
      "quantity": changedQuantity.toString(),
      "price": (oldPrice / oldQ * changedQuantity).toString(),
      "order_id": widget.repeatOrder.id.toString(),
      "calender_id": widget.repeatOrder.calender.first.id.toString()
    };
    final header = {'Authorization': 'Bearer ' + storedPrefs.accessToken};
    final response =
        await post(baseUrl + 'reorder', body: body, headers: header);
    final successM = SuccessMessage.checkResponse(response);
    if (successM.success) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (c) => OrderSuccess()));
    } else {
      Fluttertoast.showToast(msg: successM.errors ?? successM.message ?? "");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (c) => OrderFailure()));
    }
  }

  void _placeOrder() async {
    setState(() => _isLoading = true);

    Map<String, String> body = {
      "receiverName": receiverNameTextController.text,
      "receiverPhone": receiverPhoneTextController.text,
      "receiverEmail": receiverEmailTextController.text,
      "receiverCity": receiverCityTextController.text,
      "receiverStreet": receiverStreetTextController.text,
      "receiverHouse": receiverHousenumberTextController.text,
      "receiverApartment": receiverApartmentTextController.text,
      "senderName": senderNameTextController.text,
      "senderEmail": senderEmailTextController.text,
      "senderPhone": senderPhoneTextController.text,
      "appliedCoupon": _appliedCoupon?.code?.toString() ?? "",
      "isPicup": _isPickupEntry.toString(),
      "pickupId": _isPickupEntry ? shops[_selectedShopIndex].id.toString() : ""
    };

    final request = progressMulti.MultipartRequest(
        'POST', Uri.parse(baseUrl + 'placeOrder'), onProgress: (bytes, total) {
      final progress = bytes / total;
      if (progress < 1) {
        _loadinProgress = progress;
      } else {
        _loadinProgress = null;
      }
      setState(() {});
    });
    final header = {'Authorization': 'Bearer ' + storedPrefs.accessToken};
    request.headers.addAll(header);
    request.fields.addAll(body);
    cartItems.asMap().forEach((key, value) {
      request.fields.addAll({
        "cartItems[$key][hebrew]": value.isHebrew ? 'yes' : 'no',
        "cartItems[$key][ent_shabbat]": value.isSelectedCity ? 'yes' : 'no',
        "cartItems[$key][product_id]": value.calenderType.id.toString(),
        "cartItems[$key][template_id]": value.calenderTemplate.id.toString(),
        "cartItems[$key][quantity]": value.quantity.toString(),
        "cartItems[$key][price]":
            (value.calenderType.price * value.quantity).toString(),
        "cartItems[$key][city_id]":
            value.isSelectedCity ? value.selectedCity.id.toString() : "",
        "cartItems[$key][is_free_template]": value.isFreeTemplate.toString()
      });

      value.events.asMap().forEach((key1, value1) async {
        request.fields.addAll({
          "cartItems[$key][events][$key1][category_id]":
              value1.selectedCategory.id.toString(),
          "cartItems[$key][events][$key1][title]": value1.title,
          "cartItems[$key][events][$key1][date]":
              intl.DateFormat("yyyy-MM-dd").format(value1.date)
        });
        if (value1.selectedImage != null) {
          final imageList = await value1.selectedImage.readAsBytes();
          request.files.add(MultipartFile.fromBytes(
              "cartItems[$key][events][$key1][image]", imageList,
              filename: '1$key1.jpg'));
        }
      });
      value.annualDates.asMap().forEach((key1, value1) {
        request.fields.addAll(
            {"cartItems[$key][annual_date_id][$key1]": value1.id.toString()});
      });
      value.choosedImages.asMap().forEach((key1, value1) {
        request.files.add(MultipartFile.fromBytes(
            'cartItems[$key][images][$key1]', value1,
            filename: '$key1.jpg'));
      });
    });

    final streamResponse = await request.send();

    if (streamResponse.statusCode != 200) {
      print(streamResponse.statusCode);
      print(streamResponse);
      return;
    }
    final response = await Response.fromStream(streamResponse);
    setState(() => _isLoading = false);
    final successM = SuccessMessage.checkResponse(response);

    if (successM.success) {
      cartItems.clear();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (c) => OrderSuccess()));
    } else {
      Fluttertoast.showToast(msg: successM.errors ?? successM.message ?? "");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (c) => OrderFailure()));
    }
  }
}
