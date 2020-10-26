import 'package:cal4u/Models/registerResponseModel.dart';
import 'package:cal4u/Models/successMessage.dart';
import 'package:cal4u/Screens/HomePage.dart';
import 'package:cal4u/helpers/StoredPrefs.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyOtpPage extends StatefulWidget {
  final User user;
  final String accessToken;
  const VerifyOtpPage({Key key, @required this.user,@required this.accessToken}) : super(key: key);
  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  
  final otpTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    SuccessMessage.sendOtp(widget.user.mobile)
        .then((value)  {
          print(value.message);
          if (!value.success) {
            Fluttertoast.showToast(msg: value.errors ?? value.message ?? 'Something went wrong');
          }
        });
  }

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
            Align(
              child: Container(
                width: 500.w,
                height: 500.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(253, 183, 55, 1),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          spreadRadius: 0.5)
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/phoneSms.png',
                      height: 200.w,
                      fit: BoxFit.fitHeight,
                    ),
                    Text(
                      'קיבלת הודעה SMS',
                      style: TextStyle(color: Colors.white, fontSize: 50.w),
                    ),
                    SizedBox(height: 30.h)
                  ],
                ),
              ),
            ),
            Text(
              'קוד',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 50.sp),
            ),
            SizedBox(height: 10.h),
            AppTextField(hintText: '93873', controller: otpTextController),
            SizedBox(height: 40.h),
            Align(
              child: AppRaisedButton(
                onTap: () => _verifyOtpTapped(),
                title: 'Verify',
              ),
            )
          ],
        ),
      )),
    );
  }

  _verifyOtpTapped() async {
    if (otpTextController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter otp');
      return;
    }

    final success = await SuccessMessage.verifyOtp(
        widget.user.mobile, otpTextController.text);
    if (success.success == false) {
      Fluttertoast.showToast(msg: success.errors ?? success.message);
    } else {
      storedPrefs.accessToken = widget.accessToken;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => HomePage()), (route) => false);
    }
  }
}
