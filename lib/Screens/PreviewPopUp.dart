import 'package:cal4u/Screens/AddEventScreen.dart';
import 'package:cal4u/helpers/reusable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;

class PreviewPopup extends StatefulWidget {
  @override
  _PreviewPopupState createState() => _PreviewPopupState();
}

class _PreviewPopupState extends State<PreviewPopup> {
  final _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                titleRow(),
                fieldSubtitle('קטגוריה'),
                DropDownTextField(
                  hintText: 'יום הולדת ',
                  // controller: _categoryTextController,
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (c) => ListDropDown(
                              nameList: [], // categories.map((e) => e.name).toList(),
                              ontap: (i) {
                                // _selectedCatIndex = i;
                                // _categoryTextController.text =
                                //     categories.map((e) => e.name).toList()[i];
                                Navigator.of(context).pop();
                              },
                            ));
                  },
                ),
                SizedBox(height: 50.h),
                fieldSubtitle('כותרת'),
                DropDownTextField(
                  hintText: 'יום הולדת',
                  // controller: _categoryTextController,
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (c) => ListDropDown(
                              nameList: [], // categories.map((e) => e.name).toList(),
                              ontap: (i) {
                                // _selectedCatIndex = i;
                                // _categoryTextController.text =
                                //     categories.map((e) => e.name).toList()[i];
                                Navigator.of(context).pop();
                              },
                            ));
                  },
                ),
                SizedBox(height: 50.h),
                fieldSubtitle('תמונה'),
                browseImage(),
                SizedBox(height: 50.h),
                fieldSubtitle('תאריך'),
                DropDownTextField(
                  // controller: _selectedDateTextController,
                  hintText: '28/02/2021',
                  onTap: () async {
                    final now = DateTime.now();
                    final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: DateTime(now.year, 1, 1),
                        lastDate: DateTime(now.year, 12, 31));
                    final intl.DateFormat formatter =
                        intl.DateFormat('yyyy-MM-dd');
                    // _selectedDateTextController.text = formatter.format(selectedDate);
                  },
                  icon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'images/calendarYellow.png',
                        width: 10.w,
                        height: 10.w,
                      )),
                ),
                SizedBox(height: ScreenUtil().setHeight(50)),
                yelloButton(text: 'אישור', onTap: () {}),
                Text(
                  'האירוע הוסף בהצלחה',
                  style: TextStyle(
                      color: Color(0xff2D82E6),
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  
  
  }

  RaisedButton yelloButton({String text, Function onTap}) {
    return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.w),
        ),
        color: Theme.of(context).buttonColor,
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 60.sp),
        ));
  }

  Widget browseImage() {
    return InkWell(
      onTap: () async {
        final pick = await _imagePicker.getImage(source: ImageSource.gallery);
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          DropDownTextField(hintText: 'יום הולדת'),
          Container(
            height: 160.w,
            width: 300.w,
            decoration: BoxDecoration(
                color: Color(0xFFF7F6F6),
                boxShadow: [
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 2),
                ],
                borderRadius: BorderRadius.circular(150.w)),
            child: Center(child: Text('Browse')),
          ),
        ],
      ),
    );
  }

  Widget fieldTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(text,
            style: TextStyle(fontSize: 55.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget fieldSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(text, style: TextStyle(fontSize: 55.sp)),
      ),
    );
  }

  Widget titleRow() {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 1, color: Colors.black.withOpacity(0.3))
              ],
            ),
            child: Icon(Icons.clear),
          ),
        ),
        Expanded(
            child: Text(
          'הוספת אירוע ידני',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 70.sp),
        ))
      ],
    );
  }
}
