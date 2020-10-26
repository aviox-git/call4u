import 'package:cal4u/Screens/ContactUs.dart';
import 'package:cal4u/Screens/MyAlerts.dart';
import 'package:cal4u/Screens/MyDates.dart';
import 'package:cal4u/Screens/MyOrders.dart';
import 'package:cal4u/Screens/TermsCondition.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalMenu extends StatelessWidget {
  final menuItems = [
    ImageTitle(image: 'orders', title: 'ההזמנות שלי', nextWidget: MyOrders()),
    ImageTitle(image: 'starCalendar', title: 'התאריכים שלי', nextWidget: MyDatesScreen()),
    ImageTitle(image: 'bell', title: 'עדכונים', nextWidget: MyAlerts()),
    ImageTitle(image: 'message', title: 'צור קשר', nextWidget: ContactUs()),
    ImageTitle(image: 'termsCondition', title: 'תנאי שימוש', nextWidget: TermsCondition()),
  ];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: commonAppbar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TitleRedText(text: 'אזור אישי'),
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: menuItems.length,
                separatorBuilder: (c, i) => SizedBox(height: 50.h),
                itemBuilder: (c, i) => ListTile(
                      onTap: menuItems[i].nextWidget == null
                          ? null
                          : () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (c) => menuItems[i].nextWidget)),
                      leading: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 1)
                          ],
                        ),
                        child: Image.asset('images/${menuItems[i].image}.png',
                            width: 25, height: 25),
                      ),
                      title: Text(menuItems[i].title),
                    )),
            Divider(thickness: 2, height: 15),
            ShareApp()
          ],
        ),
      ),
    );
  }

 
}

class ImageTitle {
  final String image;
  final String title;
  final Widget nextWidget;
  ImageTitle(
      {@required this.image, @required this.title, @required this.nextWidget});
}
