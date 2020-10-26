import 'package:cal4u/Screens/HomePage.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderFailure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: commonAppbar(context),
      body: SingleChildScrollView(
              child: Column(
          children: [
            CircularImageText(image: 'sadFace', text: 'כישלון'),
            Text(
              """לצערנו לא הצלחנו לחייב את
כרטיס האשראי
                """,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
            ),
            Divider(thickness: 2, height: 15),
            SizedBox(height: 50.h),
            RaisedButton(
                shape: StadiumBorder(),
                color: Theme.of(context).buttonColor,
                disabledColor: Theme.of(context).buttonColor.withAlpha(100),
                padding: EdgeInsets.symmetric(vertical: 60.w, horizontal: 50.w),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'חזרה לעמוד תשלום',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 60.sp),
                )),
            SizedBox(height: 50.h),
            RaisedButton(
                shape: StadiumBorder(),
                color: Colors.white,
                disabledColor: Theme.of(context).buttonColor.withAlpha(100),
                padding: EdgeInsets.symmetric(vertical: 60.w, horizontal: 140.w),
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (c) => HomePage()),
                    (route) => false),
                child: Text(
                  'למסך הבית',
                  style: TextStyle(
                      color: Theme.of(context).buttonColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 60.sp),
                ))
          ],
        ),
      ),
    );
  }
}
