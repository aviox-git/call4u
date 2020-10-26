import 'package:cal4u/Screens/CartScreen.dart';
import 'package:cal4u/Screens/EmptyShoppingCart.dart';
import 'package:cal4u/Screens/HomePage.dart';
import 'package:cal4u/Screens/PersonalMenu.dart';
import 'package:cal4u/helpers/CartHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io' show Platform;

String baseUrl = "http://178.128.177.194/cal4u/public/api/";
String countryCode = "+972";
// String countryCode = "+91";

class CheckBoxButton extends StatelessWidget {
  final Function ontap;
  final bool isChecked;

  const CheckBoxButton(
      {Key key, @required this.ontap, @required this.isChecked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: 75.w,
        height: 75.w,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 4)
            ],
            borderRadius: BorderRadius.circular(10.w)),
        child: isChecked
            ? Image.asset('images/check.png', width: 30.w, height: 30.w)
            : SizedBox(),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  const AppTextField(
      {Key key, @required this.hintText, this.controller, this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 2)
      ], borderRadius: BorderRadius.circular(100.w), color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 40.w),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration:
              InputDecoration(border: InputBorder.none, hintText: hintText),
        ),
      ),
    );
  }
}

class AppTabBar extends StatelessWidget {
  final int selectedIndex;
  const AppTabBar({
    Key key,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 1,
            spreadRadius: 0,
            offset: Offset(0, -1),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 120.w, vertical: 30.w),
      margin: EdgeInsets.symmetric(horizontal: 50.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => PersonalMenu())),
              child: buildtabButton('profileIcon', 2)),
          InkWell(
              onTap: () {
                final aa = cartItems.isEmpty ? EmptyCartScreen() : CartScreen();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => aa));
              },
              child: buildtabButton('cartIcon', 1)),
          InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => HomePage()));
              },
              child: buildtabButton('homeIcon', 0)),
        ],
      ),
    );
  }

  SizedBox buildtabButton(String image, int index) {
    return SizedBox(
      height: 150.w,
      width: 200.w,
      child: Column(
        children: [
          Expanded(child: Image.asset('images/$image.png')),
          SizedBox(height: 8),
          Container(
              height: 3,
              color: selectedIndex == index ? Colors.red : Colors.transparent)
        ],
      ),
    );
  }
}

AppBar commonAppbar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    title: Image.asset('images/headerTitle.png',
        height: 140.w, fit: BoxFit.fitHeight),
    bottom: PreferredSize(
        child: Container(
            height: 15.h,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xffFAB61F),
              Color(0xffE1241F),
            ]))),
        preferredSize: Size.fromHeight(15.h)),
  );
}

class AppRaisedButton extends StatelessWidget {
  final String title;
  final Function onTap;

  const AppRaisedButton({Key key, this.title, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        shape: StadiumBorder(),
        color: Theme.of(context).buttonColor,
        disabledColor: Theme.of(context).buttonColor.withAlpha(100),
        padding: EdgeInsets.symmetric(vertical: 40.w, horizontal: 180.w),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 60.sp),
        ));
  }
}

class ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Container(
          color: Colors.black,
        ),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100]);
  }
}

class TitleRedText extends StatelessWidget {
  final String text;

  const TitleRedText({Key key, this.text = ''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.w800, fontSize: 70.sp),
      ),
    );
  }
}

class ListDropDown extends StatelessWidget {
  const ListDropDown({
    Key key,
    this.nameList = const [],
    this.ontap,
  }) : super(key: key);

  final List<String> nameList;
  final Function(int) ontap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.separated(
          shrinkWrap: true,
          itemCount: nameList.length,
          separatorBuilder: (c, i) => Divider(),
          itemBuilder: (c, i) => ListTile(
                onTap: () => ontap(i),
                title: Center(
                    child: Text(
                  nameList[i],
                  style: TextStyle(
                      color: Theme.of(context).buttonColor,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold),
                )),
              )),
    );
  }
}

class AddCalendarImageText extends StatelessWidget {
  final String text;
  const AddCalendarImageText({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('images/addCalendar.png', width: 80.w, height: 80.w),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
              decoration: TextDecoration.underline,
              color: Theme.of(context).buttonColor,
              fontWeight: FontWeight.bold,
              fontSize: 35.sp),
        ),
      ],
    );
  }
}

class CircularImageText extends StatelessWidget {
  final String image;
  final String text;

  const CircularImageText({Key key, @required this.image, @required this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: 500.w,
      height: 500.w,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(253, 183, 55, 1),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 0.5)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/$image.png',
            height: 200.w,
            width: 200.w,
            fit: BoxFit.contain,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 50.w),
          ),
          SizedBox(height: 30.h)
        ],
      ),
    );
  }
}

class RadioButtonTitle extends StatelessWidget {
  final String title;
  final bool selected;

  const RadioButtonTitle(
      {Key key, @required this.title, @required this.selected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
            selected ? 'images/selectRadio.png' : 'images/unSelectRadio.png',
            width: 100.w,
            height: 100.w),
        SizedBox(width: 20.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 50.sp,
          ),
        ),
      ],
    );
  }
}

extension WidgetModifier on Widget {
  // ignore: unused_element
  Widget rightAligned() => Align(alignment: Alignment.centerRight, child: this);
  Widget padding(
          [EdgeInsetsGeometry value =
              const EdgeInsets.symmetric(vertical: 16)]) =>
      Padding(
        padding: value,
        child: this,
      );
}

class ShareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var str = 'Have a look at this awesome app\n';
    str += Platform.isIOS
        ? "https://apps.apple.com/"
        : "https://play.google.com/store/apps/details?id=com.gk.cal4u";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'שיתוף ',
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.w800, fontSize: 80.sp),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
                child: InkWell(
                    onTap: () {
                      Share.share(str);
                    },
                    child: smallIcon('downloadIcon', "הורדת\n האפליקציה"))),
            SizedBox(width: 8),
            Flexible(
                child: InkWell(
                    onTap: () {
                      Share.share('try my coupon code: XXAAXXAA');
                    },
                    child: smallIcon('couponIcon', "קוד קופון \nלקניה"))),
            SizedBox(width: 8),
            Flexible(
                child: InkWell(
                    onTap: () {
                      Share.share(str);
                    },
                    child: smallIcon('shareIcon', "שיתוף\nהלוח שנה "))),
          ],
        ).padding(EdgeInsets.all(30.w))
      ],
    );
  }

  Widget smallIcon(String image, String tile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(253, 183, 55, 1),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 0.5)
              ]),
          child: Image.asset(
            'images/$image.png',
            height: 100.w,
            width: 100.w,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          tile,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class ErrorTextWithBack extends StatelessWidget {
  final String errorMessage;

  const ErrorTextWithBack({Key key, @required this.errorMessage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(errorMessage),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Text('תחזור',
                style: TextStyle(
                    color: Theme.of(context).buttonColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 80.sp)),
          ),
        ],
      ),
    );
  }
}
