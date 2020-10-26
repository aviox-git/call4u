import 'dart:async';
import 'dart:math';
import 'package:cal4u/Screens/CartScreen.dart';
import 'package:cal4u/helpers/CartHelper.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarPreviewScreen extends StatefulWidget {
  @override
  _CalendarPreviewScreenState createState() => _CalendarPreviewScreenState();
}

class _CalendarPreviewScreenState extends State<CalendarPreviewScreen> {
  int uploadCount = 0;
  int progressIndex = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (uploadCount == 13) {
        timer.cancel();
      } else {
        setState(() => uploadCount++);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: commonAppbar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TitleRedText(text: ' עריכת תמונות'),
            topGradientProgress(),
            Text(
              'עלו לשרת $uploadCount תמונות',
              style: TextStyle(
                  color: Color(0xff2D82E6),
                  fontSize: 45.sp,
                  fontWeight: FontWeight.w600),
            ).rightAligned(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '${progressIndex + 1}/13',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                    fontSize: 100.sp),
              ),
            ),
            calendarLeftRight(),
            SizedBox(height: ScreenUtil().setHeight(50)),
            AppRaisedButton(
              title: 'הבא',
              onTap: () {
                carthelper.saveCart();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (c) => CartScreen()),
                    (route) => false);
              },
            )
          ],
        ),
      ),
    );
  }

  Row calendarLeftRight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () =>
              setState(() => progressIndex = min(12, progressIndex + 1)),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 1, color: Colors.black.withOpacity(0.3))
              ],
            ),
            child: Icon(Icons.keyboard_arrow_right),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(blurRadius: 2, color: Colors.black.withOpacity(0.3))
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                  height: ScreenUtil().setWidth(500),
                  width: ScreenUtil().setWidth(500),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.memory(carthelper.choosedImages[progressIndex],
                        fit: BoxFit.cover),
                  )),
              SizedBox(
                height: ScreenUtil().setWidth(300),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () =>
              setState(() => progressIndex = max(0, progressIndex - 1)),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 1, color: Colors.black.withOpacity(0.3))
              ],
            ),
            child: Icon(Icons.keyboard_arrow_left),
          ),
        ),
      ],
    );
  }

  Container topGradientProgress() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 40,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(blurRadius: 2, color: Colors.black.withOpacity(0.3))
        ],
      ),
      child: SizedBox(
        height: 40,
        width: (1.wp - 16) * uploadCount / 13,
        child: DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
          Color(0xffFAB61F),
          Color(0xffE1241F),
        ]))),
      ),
    );
  }
}
