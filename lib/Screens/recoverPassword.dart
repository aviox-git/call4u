import 'package:cal4u/Models/successMessage.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecoverPasswordPage extends StatefulWidget {
  final String mobile;

  const RecoverPasswordPage({Key key, @required this.mobile}) : super(key: key);
  @override
  _RecoverPasswordPageState createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final otpTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SuccessMessage.sendOtp(widget.mobile).then((value) {
      print(value.message);
      if (!value.success) {
        Fluttertoast.showToast(
            msg: value.errors ?? value.message ?? 'Something went wrong');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: commonAppbar(context),
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
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 80.sp),
            ),
            SizedBox(height: 40.h),
            Text(
              'הזן את הקוד שקיבלת בSMS',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 50.sp),
            ),
            SizedBox(height: 10.h),
            AppTextField(
              hintText: 'ישראל ישראלי',
              controller: otpTextController,
            ),
            SizedBox(height: 40.h),
            Text(
              'בחר סיסמה חדשה',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 50.sp),
            ),
            SizedBox(height: 10.h),
            AppTextField(
              hintText: 'ישראל ישראלי',
              controller: passwordTextController,
            ),
            SizedBox(height: 40.h),
            Text(
              'הקלד שוב את סיסמתך החדשה',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 50.sp),
            ),
            SizedBox(height: 10.h),
            AppTextField(
              hintText: '0541234567',
              controller: confirmPasswordController,
            ),
            SizedBox(height: 60.h),
            Align(
              child: RaisedButton(
                  shape: StadiumBorder(),
                  color: Theme.of(context).buttonColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 40.w, horizontal: 160.w),
                  onPressed: () => _submitTapped(),
                  child: Text(
                    'כניסה',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 60.sp),
                  )),
            ),
          ],
        ),
      )),
    );
  }

  _submitTapped() async {
    if (otpTextController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter OTP');
      return;
    }
    if (passwordTextController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your password');
      return;
    }

    if (confirmPasswordController.text.trim().length < 10) {
      Fluttertoast.showToast(msg: 'Number enter confirm password');
      return;
    }

    if (passwordTextController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(
          msg: 'Password does not match with confirm password');
      return;
    }

    final aa = await SuccessMessage.forgetPassword(widget.mobile,
        otpTextController.text.trim(), passwordTextController.text.trim());
    Fluttertoast.showToast(msg: aa.errors ?? aa.message);
  }
}
