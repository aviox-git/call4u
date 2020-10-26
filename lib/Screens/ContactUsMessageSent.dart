import 'package:flutter/material.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsMessageSent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: commonAppbar(context),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            CircularImageText(image: 'messageSent', text: 'הצלחה'),
            Text(
              """
תודה על פנייתך, 
ניצור אתך קשר בהקדם
            """,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55.sp),
            ),
            Spacer(),
            AppTabBar(selectedIndex: 2)
          ],
        ),
      ),
    );
  }
}
