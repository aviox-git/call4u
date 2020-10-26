import 'package:cal4u/Models/successMessage.dart';
import 'package:cal4u/Screens/ContactUsMessageSent.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final phoneTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: commonAppbar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleRedText(text: 'צור קשר'),
                  SizedBox(height: 40.h),
                  Text(
                    'טלפון',
                    style: TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 50.sp),
                  ),
                  SizedBox(height: 10.h),
                  AppTextField(hintText: '', controller: phoneTextController),
                  SizedBox(height: 40.h),
                  SizedBox(height: 40.h),
                  Text(
                    'מייל',
                    style: TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 50.sp),
                  ),
                  SizedBox(height: 10.h),
                  AppTextField(
                    hintText: 'xx@yy.com',
                    controller: emailTextController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(height: 40.h),
                  Text(
                    'תוכן הודעה',
                    style: TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 50.sp),
                  ),
                  SizedBox(height: 10.h),
                  DecoratedBox(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.3),
                              blurRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(100.w),
                        color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 40.w),
                      child: TextField(
                        controller: messageTextController,
                        minLines: 5,
                        maxLines: 6,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Align(
                      child: AppRaisedButton(
                          title: 'שליחה', onTap: () => _sendTapped())),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
          AppTabBar(selectedIndex: 2)
        ],
      ),
    );
  }

  void _sendTapped() async {
    if (messageTextController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'אנא הכנס הודעה');
      return;
    }

    if (phoneTextController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'אנא הזן מספר טלפון');
      return;
    }

    if (emailTextController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'אנא הכנס דוא"ל');
      return;
    }

    final response = await SuccessMessage.contactUs(
        email: emailTextController.text,
        phone: phoneTextController.text,
        message: messageTextController.text);

    if (response.success) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (c) => ContactUsMessageSent()));
    } else {
      Fluttertoast.showToast(msg: 'לא יכול היה לשלוח הודעה');
    }
  }
}
