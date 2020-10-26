import 'dart:ui';

import 'package:cal4u/Screens/HomePage.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: commonAppbar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TitleRedText(text: 'עגלה'),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: 500.w,
              height: 500.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(253, 183, 55, 1),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 2, spreadRadius: 0.5)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/sadFace.png',
                    height: 200.w,
                    fit: BoxFit.fitHeight,
                  ),
                  Text(
                    'עגלה ריקה',
                    style: TextStyle(color: Colors.white, fontSize: 50.w),
                  ),
                  SizedBox(height: 30.h)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 150.sp),
              child: Text(
                "נולום ארווס סאפיאן - פוסיליס קוויס, אקווזמן קוואזי במר מודוף. אודיפו בלאסטיק מונופץ קליר, בנפת נפקט למסון בלרק",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45.sp,
                ),
              ),
            ),
            SizedBox(height: 100.h),
            AppRaisedButton(
              title: 'לעמוד הבית',
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (c) => HomePage()),
                    (route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
