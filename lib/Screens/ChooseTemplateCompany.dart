import 'package:cal4u/Models/GetCalenderModel.dart';
import 'package:cal4u/Screens/ChooseTemplate.dart';
import 'package:cal4u/Screens/TemplateDetail.dart';
import 'package:cal4u/helpers/CartHelper.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseTemplateCompany extends StatelessWidget {
  final Calender calender;

  const ChooseTemplateCompany({Key key, @required this.calender})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
        appBar: commonAppbar(context),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Column(children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Cellcom',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w800,
                      fontSize: 70.sp),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 50.h, horizontal: 150.w),
                child: AspectRatio(
                    aspectRatio: 3 / 5, child: CalTemplate(calender: calender)),
              ),
              AppRaisedButton(
                title: 'המשך',
                onTap: () {
                  carthelper.calenderTemplate = calender;
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) => TemplateDetail()));
                },
              ),
              SizedBox(height: 50.h),
              AppTabBar()
            ])));
  }
}
