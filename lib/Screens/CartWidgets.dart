import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartPopUp extends StatelessWidget {
  final String message;
  final Function onAccept;
  const CartPopUp({
    Key key,
    @required this.message,
    @required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1,
                              color: Colors.black.withOpacity(0.3))
                        ],
                      ),
                      child: Icon(Icons.clear),
                    ),
                  ),
                ),
                Text(
                  message,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                        shape: StadiumBorder(),
                        color: Theme.of(context).buttonColor,
                        padding: EdgeInsets.symmetric(
                            vertical: 20.w, horizontal: 40.w),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'ביטול',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 60.sp),
                        )),
                    RaisedButton(
                        shape: StadiumBorder(),
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: 20.w, horizontal: 40.w),
                        onPressed: () => onAccept(),
                        child: Text(
                          'אישור',
                          style: TextStyle(
                              color: Theme.of(context).buttonColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 60.sp),
                        )),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class AddCouponButton extends StatelessWidget {
  const AddCouponButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('images/yellowStripe.png', height: 200.h),
        Container(
          padding: EdgeInsets.fromLTRB(150.w, 10.h, 20.w, 10.h),
          height: 200.h,
          child: Row(
            children: [
              Image.asset('images/couponIcon.png', height: 150.w, width: 150.w),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.w),
                  width: 2,
                  height: 150.w,
                  color: Colors.white),
              Expanded(
                  child: Text(
                "במידה ויש קוד קופון יש להכניס אותו במקום המיועד במסך הבא",
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white),
              )),
            ],
          ),
        )
      ],
    );
  }
}

class CouponTextArea extends StatelessWidget {
  final Function onApply;
  final TextEditingController couponController;

  const CouponTextArea(
      {Key key, @required this.onApply, @required this.couponController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/couponIcon.png', height: 150.w, width: 150.w),
              SizedBox(width: 50.w),
              Text('קופון הנחה',
                  style: TextStyle(color: Colors.white, fontSize: 60.sp)),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: couponController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'AAX761'),
                )),
                Container(
                    color: Colors.grey,
                    width: 1,
                    height: 30,
                    padding: EdgeInsets.symmetric(horizontal: 2)),
                FlatButton(
                    onPressed: () => onApply(),
                    child: Text(
                      'Apply',
                      style: TextStyle(color: Theme.of(context).buttonColor),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
