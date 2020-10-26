import 'package:cal4u/Screens/EmptyShoppingCart.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => EmptyCartScreen()),
            (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: commonAppbar(context),
        body: Column(
          children: [
            CircularImageText(image: 'thumbsUp', text: 'הצלחה'),
            Text(
              'מספר הזמנה: 937366',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
            ),
            Text('20/08/20'),
            Divider(thickness: 2, height: 15),
            ShareApp()
          ],
        ),
      ),
    );
  }
}
