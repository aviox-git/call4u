import 'package:cal4u/Models/registerResponseModel.dart';
import 'package:cal4u/Screens/HomePage.dart';
import 'package:cal4u/helpers/StoredPrefs.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:cal4u/Screens/recoverPassword.dart';
import 'package:cal4u/Screens/registerPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isTermsConditionAccepted = false;
  final phoneTextController = TextEditingController();
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
              'כניסה',
              style: TextStyle(
                  color: Color(0xffE0221D),
                  fontWeight: FontWeight.bold,
                  fontSize: 80.sp),
            ),
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
                  controller: phoneTextController,
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
                      hintText: 'ישראל ישראלי'),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Text(
              'סיסמא',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 50.sp),
            ),
            SizedBox(height: 10.h),
            AppTextField(
                hintText: '********', controller: passwordTextController),
            SizedBox(height: 40.h),
            Row(
              children: <Widget>[
                CheckBoxButton(
                    ontap: () => setState(() => _isTermsConditionAccepted =
                        !_isTermsConditionAccepted),
                    isChecked: _isTermsConditionAccepted),
                SizedBox(width: 25.w),
                Text(
                  'זכור אותי',
                  style: TextStyle(fontSize: 50.sp),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    if (phoneTextController.text.trim().isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Please enter your phone number');
                      return;
                    }

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => RecoverPasswordPage(
                            mobile: countryCode +
                                phoneTextController.text.trim())));
                  },
                  child: Text(
                    'שכחת סיסמה?',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 50.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.h),
            Align(
              child: RaisedButton(
                  shape: StadiumBorder(),
                  color: Theme.of(context).buttonColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 40.w, horizontal: 180.w),
                  onPressed: () => _loginTapped(),
                  child: Text(
                    'כניסה',
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
                color: Color.fromRGBO(61, 139, 200, 1),
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
                color: Color.fromRGBO(209, 74, 48, 1),
                padding:
                    EdgeInsets.symmetric(vertical: 40.w, horizontal: 150.w),
                onPressed: () => _googleSignInTapped(),
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
                      text: 'אין לך עדיין חשבון?',
                      children: [
                        TextSpan(text: '  '),
                        TextSpan(
                            text: 'לחץ פה להרשמה',
                            style: TextStyle(
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (c) => RegisterPage())))
                      ]),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  void _googleSignInTapped() async {
    final google = GoogleSignIn(scopes: ['email']);
    final googleUser = await google.signIn();
    final body = {
      "name": googleUser.displayName,
      "email": googleUser.email,
      "type": 2.toString(),
      "googleplus_id": googleUser.id
    };
    final user = await RegisterUserResponse.socialLogin(body);
    if (user.success == false) {
      Fluttertoast.showToast(msg: user.errors ?? user.message);
      return;
    }
    storedPrefs.accessToken = user.accessToken;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => HomePage()), (route) => false);
  }

    void _fbSignInTapped() async {
    final google = GoogleSignIn(scopes: ['email']);
    final fbuser = await google.signIn();
    final body = {
      "name": fbuser.displayName,
      "email": fbuser.email,
      "type": 1.toString(),
      "facebook_id": fbuser.id
    };
    final user = await RegisterUserResponse.socialLogin(body);
    if (user.success == false) {
      Fluttertoast.showToast(msg: user.errors ?? user.message);
      return;
    }
    storedPrefs.accessToken = user.accessToken;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => HomePage()), (route) => false);
  }

  _loginTapped() async {
    if (!_isTermsConditionAccepted) {
      Fluttertoast.showToast(msg: 'Please accept terms and conditions');
      return;
    }

    if (phoneTextController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your phone number');
      return;
    }
    if (passwordTextController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your password');
      return;
    }

    if (phoneTextController.text.trim().length != 10) {
      Fluttertoast.showToast(msg: 'Number should be 10 characters');
      return;
    }
    final number = countryCode + phoneTextController.text.trim();
    final user = await RegisterUserResponse.loginUser(
        number, passwordTextController.text.trim());
    if (user.success == false) {
      Fluttertoast.showToast(msg: user.errors ?? user.message);
      return;
    }
    storedPrefs.accessToken = user.accessToken;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => HomePage()), (route) => false);
  }
}
