import 'package:cal4u/Models/registerResponseModel.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:cal4u/Screens/loginPage.dart';
import 'package:cal4u/Screens/verifyOtp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _isTermsConditionAccepted = false;
  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final numberTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.all(40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 1.wp),
            Text(
              'הרשמה',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 80.sp),
            ),
            SizedBox(height: 40.h),
            Text(
              'שם ושם משפחה',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 50.sp),
            ),
            SizedBox(height: 10.h),
            AppTextField(
                hintText: 'ישראל ישראלי',
                controller: nameTextController,
                keyboardType: TextInputType.name),
            SizedBox(height: 40.h),
            Text(
              'טלפון',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 50.sp),
            ),
            SizedBox(height: 10.h),
            DecoratedBox(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 2)
                  ],
                  borderRadius: BorderRadius.circular(100.w),
                  color: Colors.white),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 40.w),
                child: TextField(
                  controller: numberTextController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 11.0),
                        child: Text(countryCode,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 50.sp)),
                      ),
                      border: InputBorder.none,
                      hintText: 'ישראל'),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Text(
              'מייל',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 50.sp),
            ),
            SizedBox(height: 10.h),
            AppTextField(
              hintText: 'xx@yy.com',
              controller: emailTextController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 40.h),
            Text(
              'סיסמא',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 50.sp),
            ),
            SizedBox(height: 10.h),
            AppTextField(
                hintText: '**********',
                controller: passwordTextController,
                keyboardType: TextInputType.visiblePassword),
            SizedBox(height: 40.h),
            Row(
              children: <Widget>[
                CheckBoxButton(
                    ontap: () => setState(() => _isTermsConditionAccepted =
                        !_isTermsConditionAccepted),
                    isChecked: _isTermsConditionAccepted),
                SizedBox(width: 25.w),
                Expanded(
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 40.sp, color: Color(0xff383838)),
                          text: 'לחיצה על ההרשמה מאשר את ',
                          children: [
                        TextSpan(
                          text: 'תנאי השימוש באתר',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        )
                      ])),
                )
              ],
            ),
            SizedBox(height: 40.h),
            Align(
              child: RaisedButton(
                  shape: StadiumBorder(),
                  color: Theme.of(context).buttonColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 50.w, horizontal: 150.w),
                  onPressed: () => _signupTapped(),
                  child: Text(
                    'להירשם',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 60.sp),
                  )),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: Colors.black45,
                )),
                ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('אוֹ'),
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: Colors.black45,
                ))
              ],
            ),
            FlatButton(
                shape: StadiumBorder(),
                color: Color(0xff448CCB),
                padding:
                    EdgeInsets.symmetric(vertical: 40.w, horizontal: 150.w),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Connect with Facebook',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 50.sp),
                    ),
                    SizedBox(width: 30.w),
                    Image.asset(
                      'images/facebook.png',
                      width: 90.w,
                      height: 90.w,
                    ),
                  ],
                )),
            SizedBox(height: 50.h),
            FlatButton(
                shape: StadiumBorder(),
                color: Color(0xffCD492A),
                padding:
                    EdgeInsets.symmetric(vertical: 40.w, horizontal: 150.w),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Connect with Google',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 50.sp),
                    ),
                    SizedBox(width: 30.w),
                    Image.asset(
                      'images/google.png',
                      width: 90.w,
                      height: 90.w,
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                child: Text.rich(
                  TextSpan(
                      style: TextStyle(
                          fontSize: 40.sp, fontWeight: FontWeight.w500),
                      text: 'יש לך כבר חשבוןֹ?',
                      children: [
                        TextSpan(text: '  '),
                        TextSpan(
                            text: 'לחץ כאן לכניסה',
                            style: TextStyle(
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (c) => LoginPage())))
                      ]),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  _signupTapped() async {
    if (!_isTermsConditionAccepted) {
      Fluttertoast.showToast(msg: 'Please accept terms and conditions');
      return;
    }

    if (nameTextController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your name');
      return;
    }

    if (emailTextController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your email');
      return;
    }
    if (numberTextController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your phone number');
      return;
    }
    if (passwordTextController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your password');
      return;
    }

    if (numberTextController.text.trim().length != 10) {
      Fluttertoast.showToast(msg: 'Number should be 10 characters');
      return;
    }
    final user = await RegisterUserResponse.registerUser(
        name: nameTextController.text,
        number: countryCode + numberTextController.text.trim(),
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim());
    if (user.success == false) {
      Fluttertoast.showToast(msg: user.errors ?? user.message);
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (c) =>
            VerifyOtpPage(user: user.user, accessToken: user.accessToken)));
  }
}
